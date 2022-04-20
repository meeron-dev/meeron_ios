//
//  TokenRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/20.
//

import Foundation

protocol TokenRepository {
    func saveToken(token: Token) -> Bool
}
