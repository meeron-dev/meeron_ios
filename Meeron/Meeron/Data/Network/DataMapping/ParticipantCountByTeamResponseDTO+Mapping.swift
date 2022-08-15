//
//  ParticipantCountByTeamResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/08/16.
//

import Foundation

struct ParticipantCountByTeamResponseDTO: Codable {
    let teamId:Int
    let teamName:String
    let attends:Int
    let absents:Int
    let unknowns:Int
}

extension ParticipantCountByTeamResponseDTO {
    func toDomain() -> ParticipantCountByTeam {
        return .init(teamId: teamId,
                     teamName: teamName,
                     attends: attends,
                     absents: absents,
                     unknowns: unknowns)
    }
}
