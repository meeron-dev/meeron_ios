//
//  ParticipantInfoResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/08/16.
//

import Foundation

struct ParticipantInfoResponseDTO:Codable {
    let attends:[WorkspaceUserResponseDTO]
    let absents:[WorkspaceUserResponseDTO]
    let unknowns:[WorkspaceUserResponseDTO]
}

extension ParticipantInfoResponseDTO {
    func toDomain() -> ParticipantInfo {
        return .init(attends: attends.map{$0.toDomain()},
                     absents: absents.map{$0.toDomain()},
                     unknowns: unknowns.map{$0.toDomain()})
    }
}
