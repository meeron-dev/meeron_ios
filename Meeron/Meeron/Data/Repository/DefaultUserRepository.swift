//
//  DefaultUserRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/23.
//

import Foundation
import RxSwift

class DefaultUserRepository: UserRepository {
    
    
    let api = API()
    
    func reissueToken() -> Observable<Token?> {
        guard let refreshToken = KeychainManager().read(service: "Meeron", account: "refreshToken") else {return Observable.just(nil)}
        
        let resource = Resource<Token>(url: URLConstant.reissue, parameter: [:], headers: [.authorization(bearerToken: refreshToken)], method: .post, encodingType: .URLEncoding)
        
        return api.requestData(resource: resource)
        
    }
    
    func fetchUser() -> Observable<User?> {
        
        guard let accessToken = KeychainManager().read(service: "Meeron", account: "accessToken") else {return Observable.just(nil)}
        
        let resource = Resource<User>(url: URLConstant.user, parameter:[:], headers: [.authorization(bearerToken: accessToken)], method: .get, encodingType: .URLEncoding)
        
        return api.requestData(resource: resource)
    }
    
    func fetchUserWorkspace(id:Int) -> Observable<UserWorkspace?> {
        
        let resource = Resource<UserWorkspace>(url: URLConstant.userWorkspace+"/\(id)/workspace-users", parameter: ["userId":String(id)], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
        
        print("🤭", resource)
        
        return api.requestData(resource: resource)
    }
    
    func saveUserId(id:Int) {
        UserDefaults.standard.set(String(id), forKey: "userId")
        print("USER ID :", id)
    }
    
    func saveUserWorkspace(data:[MyWorkspaceUser]) {
        print("📕워크스페이스", data)
        UserDefaults.standard.set(String(data[0].workspaceId), forKey:"workspaceId")
        UserDefaults.standard.set(String(data[0].workspaceUserId), forKey: "workspaceUserId")
        UserDefaults.standard.set(data[0].nickname, forKey: "workspaceNickname")
        UserDefaults.standard.set(data[0].workspaceAdmin, forKey: "workspaceAdmin")
        
        print("ADMIN",UserDefaults.standard.bool(forKey: "workspaceAdmin"))
    }
    
    func fetchWorkspaceInfo() -> Observable<Workspace?> {
        print("🟡")
        guard let workspaceId = UserDefaults.standard.string(forKey: "workspaceId") else {return Observable.just(nil)}
        
        let resource = Resource<Workspace>(url: URLConstant.workspace+"/\(workspaceId)", parameter: [:], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
        return api.requestData(resource: resource)
    }
    
    func saveWorkspace(data:Workspace) {
        UserDefaults.standard.set(data.workspaceName, forKey: "workspaceName")
    }
    
    func fetchWorkspaceUser(workspaceUserId:String) -> Observable<WorkspaceUser?> {
        let resource = Resource<WorkspaceUser>(url: URLConstant.workspaceUsers+"/\(workspaceUserId)", parameter:[:], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding )
        
        return api.requestData(resource: resource)
    }
    
    func modifyUserProfile(data: WorkspaceProfile) -> Observable<Bool> {
        guard let workspaceUserId = UserDefaults.standard.string(forKey: "workspaceUserId") else {return Observable.just(false)}
        let jsonData:[String : Any] = [ "nickname" : data.nickname, "position" : data.position, "email" : data.email, "phone":  data.phoneNumber]
        
        
        var param : [String:Any] = [:]
        if let theJSONData = try? JSONSerialization.data(
                withJSONObject: jsonData,
                options: []) {
                let theJSONText = String(data: theJSONData,
                                         encoding: .utf8)
                
                param = ["request" : theJSONText ?? ""]
            }
        let resource = Resource<Bool>(url: URLConstant.workspaceUsers+"/\(workspaceUserId)", parameter: param, headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .put, encodingType: .URLEncoding )
        
        return api.upload(resource: resource, data: data.image, fileName: "image.jpeg", mimeType: "image/jpeg")
    }
    
}
