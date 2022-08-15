//
//  AgendaIdsResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/08/16.
//

import Foundation

struct AgendaIdsResponseDTO:Codable {
    let createdAgendaIds:[Int]
}

extension AgendaIdsResponseDTO {
    func toDomain() -> AgendaIds {
        return .init(createdAgendaIds: createdAgendaIds)
    }
}
