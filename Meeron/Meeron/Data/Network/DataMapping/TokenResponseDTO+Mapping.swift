//
//  TokenResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/18.
//

import Foundation

struct TokenResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
}

extension TokenResponseDTO {
    func toDomain() -> Token {
        return .init(accessToken: accessToken,
                     refreshToken: refreshToken)
    }
}
