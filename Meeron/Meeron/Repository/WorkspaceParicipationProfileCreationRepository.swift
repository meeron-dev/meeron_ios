//
//  WorkspaceParicipationProfileCreationRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/24.
//

import Foundation
import Alamofire
import RxSwift

class WorkspaceParicipationProfileCreationRepository {
    let headers:HTTPHeaders = [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)]
    
    let api = API()
    
    func checkWorkspace(workspaceId:String) -> Observable<Bool>{
        let resource = Resource<Bool>(url: (URLConstant.workspace+"/\(workspaceId)"), parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        return api.requestResponse(resource: resource)
        
    }
    
    func checkNickname(nickname:String, workspaceId:String) ->Observable<WorkspaceProfileNicknameCheckResponse?> {
        let urlString = URLConstant.workspaceUsers+"/nickname?workspaceId=\(workspaceId)&nickname=\(nickname)"
        
        let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        
        guard let encodedURLString = encodedURLString else {
            return Observable.just(nil)
        }
        
        let resource = Resource<WorkspaceProfileNicknameCheckResponse>(url: encodedURLString, parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        return api.requestData(resource: resource)
        
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
}
