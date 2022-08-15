//
//  ParticipantCountsByTeamResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/08/16.
//

import Foundation

struct ParticipantCountsByTeamResponseDTO: Codable {
    let attendees:[ParticipantCountByTeamResponseDTO]
}

extension ParticipantCountsByTeamResponseDTO {
    func toDomain() -> [ParticipantCountByTeam] {
        return attendees.map{$0.toDomain()}
    }
}
