//
//  SignUpRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/19.
//

import Foundation
import Alamofire
import RxSwift

class SignUpRepository {
    let headers:HTTPHeaders = [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)]
    let api = API()
    
    
    func loadLoginToken(email:String, nickname:String?, profileImageUrl:String?, provider:String) -> Observable<Token?> {
        let resource:Resource<Token>
        
        if let nickname = nickname, let profileImageUrl = profileImageUrl{
            resource = Resource<Token>(url: URLConstant.login, parameter:["email":"test4@test.com", "nickname":nickname, "profileImageUrl":profileImageUrl,"provider":provider], headers: ["Content-Type": "application/json"], method: .post, encodingType: .JSONEncoding)
        }else{
            resource = Resource<Token>(url: URLConstant.login, parameter:["email":"test4@test.com","provider":provider], headers: ["Content-Type": "application/json"], method: .post, encodingType: .JSONEncoding)
        }
        

        return api.requestData(resource: resource)
        
    }
    
    func loadUser() -> Observable<User?> {
        let resource = Resource<User>(url: URLConstant.user, parameter:[:], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
        
        return api.requestData(resource: resource)
    }
    
    func reissueToken() -> Observable<Token?> {
        let resource = Resource<Token>(url: URLConstant.reissue, parameter: [:], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .post, encodingType: .URLEncoding)
        
        return api.requestData(resource: resource)
        
    }
    
    func loadUserWorkspace(id:Int) -> Observable<UserWorkspace?> {
        let resource = Resource<UserWorkspace>(url: URLConstant.userWorkspace+"/\(id)/workspace-users", parameter: ["userId":String(id)], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
        
        return api.requestData(resource: resource)
    }
    
    
    func patchUserName(name:String) -> Observable<Bool>{
        let resource = Resource<Bool>(url: URLConstant.userName, parameter: ["name":name], headers: headers, method: .patch, encodingType: .JSONEncoding)
        return api.requestResponse(resource: resource)
    }
    
    
}
