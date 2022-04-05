//
//  WorkspaceCreationRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/21.
//

import Foundation
import Alamofire
import RxSwift
import FirebaseDynamicLinks

class WorkspaceCreationRepository {
    
    let headers:HTTPHeaders = [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)]
    
    let api = API()
    
    func postWorkspaceName(name:String) -> Observable<WorkspaceCreationResponse?> {
        
        let resource = Resource<WorkspaceCreationResponse>(url: URLConstant.workspace, parameter: ["name":name], headers: headers, method: .post, encodingType: .JSONEncoding)
        
        return api.requestData(resource: resource)
    }
    
    func postWorkspaceTeamName(name:String, workspaceId:Int) -> Observable<Bool> {
        let resource = Resource<Bool>(url: URLConstant.teamInWorkspace, parameter: ["workspaceId":workspaceId, "teamName":name], headers: headers, method: .post, encodingType: .JSONEncoding)
        return api.requestResponse(resource: resource)
    }
    
    func postProfile(workspaceProfile:WorkspaceProfile, workspaceId:String) -> Observable<Bool> {
        let jsonData:[String : Any] = ["workspaceId" : Int(workspaceId)!,
                         "nickname" : workspaceProfile.nickname,
                         "position" : workspaceProfile.position,
                         "email" : workspaceProfile.email,
                    "phone":  workspaceProfile.phoneNumber]
        
        
        var param : [String:Any] = [:]
        if let theJSONData = try? JSONSerialization.data(
                withJSONObject: jsonData,
                options: []) {
                let theJSONText = String(data: theJSONData,
                                         encoding: .utf8)
                
                param = ["request" : theJSONText ?? ""]
            }
        let resource = Resource<Bool>(url: URLConstant.workspaceUsers, parameter: param, headers: headers, method: .post, encodingType: .URLEncoding )
        
        return api.upload(resource: resource, data: workspaceProfile.image, fileName: "image", mimeType: "image/png")
    }
    
    func createWorkspaceDynamicLink(workspaceId:Int, completion: @escaping (String?)->() ) {
        
        let link = URL(string: "https://ronmee.page.link?id=\(workspaceId)")!
        let domainURIPrefix = "https://ronmee.page.link"
        let referralLink = DynamicLinkComponents(link: link, domainURIPrefix: domainURIPrefix)
        
        referralLink?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.fourtune.Meeron")
        referralLink?.iOSParameters?.minimumAppVersion = "1.0.1"
        referralLink?.iOSParameters?.appStoreID = "0"
        
        referralLink?.androidParameters = DynamicLinkAndroidParameters(packageName: "fourtune.meeron")
        
        
        referralLink?.shorten(completion: {  shortURL, warnings, error in
            guard let url = shortURL else {return}
            print("✔️:", url)
            completion("\(url)")
            return
        })
        completion(nil)
        return
    }
    
}
