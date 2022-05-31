//
//  SaveTokenUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/06/01.
//

import Foundation

class SaveTokenUseCase {
    let tokenRepository = DefaultTokenRepository()
    func execute(token: Token) -> Bool {
        return tokenRepository.saveToken(token: token)
    }
}
