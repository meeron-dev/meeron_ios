//
//  TeamsResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/07/11.
//

import Foundation

struct TeamsResponseDTO: Codable {
    let teams: [TeamResponseDTO]
}

extension TeamsResponseDTO {
    func toDomain() -> [Team] {
        return teams.map{$0.toDomain()}
    }
}
