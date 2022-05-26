//
//  TeamResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/26.
//

import Foundation

struct TeamResponseDTO: Codable {
    let teamId: Int
    let teamName: String
}

extension TeamResponseDTO {
    func toDomain() -> Team {
        return .init(teamId: teamId,
                     teamName: teamName)
    }
}
