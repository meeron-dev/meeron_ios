//
//  TeamCreationResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/08/16.
//

import Foundation

struct TeamCreationResponseDTO: Codable {
    var createdTeamId: Int
}

extension TeamCreationResponseDTO {
    func toDomain() -> TeamCreation {
        return .init(createdTeamId: createdTeamId)
    }
}
