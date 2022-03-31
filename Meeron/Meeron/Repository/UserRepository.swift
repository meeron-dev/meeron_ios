//
//  UserRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/23.
//

import Foundation
import RxSwift

class UserRepository {
    let api = API()
    
    func reissueToken() -> Observable<Token?> {
        let resource = Resource<Token>(url: URLConstant.reissue, parameter: [:], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "refreshToken")!)], method: .post, encodingType: .URLEncoding)
        
        return api.requestData(resource: resource)
        
    }
    
    func loadUser() -> Observable<User?> {
        let resource = Resource<User>(url: URLConstant.user, parameter:[:], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
        
        return api.requestData(resource: resource)
    }
    
    func loadUserWorkspace(id:Int) -> Observable<UserWorkspace?> {
        let resource = Resource<UserWorkspace>(url: URLConstant.userWorkspace+"/\(id)/workspace-users", parameter: ["userId":String(id)], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
        
        return api.requestData(resource: resource)
    }
    
    func saveUserId(id:Int) {
        UserDefaults.standard.set(String(id), forKey: "userId")
        print("USER ID :", id)
    }
    
    func saveUserWorkspace(data:[MyWorkspaceUser]) {
        UserDefaults.standard.set(String(data[0].workspaceId), forKey:"workspaceId")
        UserDefaults.standard.set(String(data[0].workspaceUserId), forKey: "workspaceUserId")
        UserDefaults.standard.set(data[0].nickname, forKey: "workspaceNickname")
        UserDefaults.standard.set(data[0].workspaceAdmin, forKey: "workspaceAdmin")
        
        print("ADMIN",UserDefaults.standard.bool(forKey: "workspaceAdmin"))
    }
    
    func loadWorkspaceInfo() -> Observable<Workspace?> {
        
        guard let workspaceId = UserDefaults.standard.string(forKey: "workspaceId") else {return Observable.just(nil)}
        
        let resource = Resource<Workspace>(url: URLConstant.workspace+"/\(workspaceId)", parameter: [:], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
        return api.requestData(resource: resource)
    }
    
    func saveWorkspace(data:Workspace) {
        UserDefaults.standard.set(data.workspaceName, forKey: "workspaceName")
    }
}
