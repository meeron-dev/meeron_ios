//
//  DefaultTokenRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/20.
//

import Foundation

class DefaultTokenRepository: TokenRepository {
    
    let keyChainManager = KeychainManager()
    
    func saveToken(token: Token) -> Bool {
        return keyChainManager.saveLoginToken(accessToken: token.accessToken, refreshToken: token.refreshToken)
    }
    
    
}
