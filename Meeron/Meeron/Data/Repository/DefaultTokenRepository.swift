//
//  DefaultTokenRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/20.
//

import Foundation
import RxSwift

class DefaultTokenRepository: TokenRepository {
    
    let keyChainManager = KeychainManager()
    
    func fetchLoginToken(email:String, nickname:String?, profileImageUrl:String?, provider:String) -> Observable<Token?> {
        let resource:Resource<TokenResponseDTO>
        
        if let nickname = nickname, let profileImageUrl = profileImageUrl{
            resource = Resource<TokenResponseDTO>(url: URLConstant.login, parameter:["email":email, "nickname":nickname, "profileImageUrl":profileImageUrl,"provider":provider], headers: ["Content-Type": "application/json"], method: .post, encodingType: .JSONEncoding)
        }else{
            resource = Resource<TokenResponseDTO>(url: URLConstant.login, parameter:["email":email,"provider":provider], headers: ["Content-Type": "application/json"], method: .post, encodingType: .JSONEncoding)
        }
        
        return API.requestData(resource: resource)
            .map{$0?.toDomain()}
    }
    
    func saveToken(token: Token) -> Bool {
        return keyChainManager.saveLoginToken(accessToken: token.accessToken, refreshToken: token.refreshToken)
    }
    
}
