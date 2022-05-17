//
//  AuthRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/04.
//

import Foundation
import Alamofire
import RxSwift

class AuthRepository {
    
    let keychainManager = KeychainManager()
    
    let disposeBag = DisposeBag()
    
    func logout() -> Observable<Bool> {
        let headers:HTTPHeaders = [ "Authorization": "Bearer " + KeychainManager().read(service: "Meeron", account: "accessToken")!, "refreshToken": "Bearer " + KeychainManager().read(service: "Meeron", account: "refreshToken")!]
        
        let resource = Resource<Bool>(url: URLConstant.logout, parameter: [:], headers: headers, method: .post, encodingType: .URLEncoding)
        return API.requestResponse(resource: resource)
    }

    
    func withdraw() -> Observable<Bool> {
        let resource = Resource<Bool>(url: URLConstant.withdraw, parameter: [:], headers: [ "Authorization": "Bearer " + KeychainManager().read(service: "Meeron", account: "accessToken")!], method: .delete, encodingType: .URLEncoding)
        return API.requestResponse(resource: resource)
    }
    
    func deleteToken() {
        keychainManager.deleteToken()
    }
    
    func deleteWorkspaceInfo() {
        UserDefaults.standard.removeObject(forKey: "workspaceId")
        UserDefaults.standard.removeObject(forKey: "workspaceName")
        UserDefaults.standard.removeObject(forKey: "workspaceUserId")
        UserDefaults.standard.removeObject(forKey: "workspaceNickname")
        UserDefaults.standard.removeObject(forKey: "workspaceAdmin")
        UserDefaults.standard.removeObject(forKey: "workspaceUserId")
    }
    
    func deleteUserInfo() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        
    }
}
