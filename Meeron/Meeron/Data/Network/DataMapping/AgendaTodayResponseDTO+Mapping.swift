//
//  AgendaTodayResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/26.
//

import Foundation

struct AgendaTodayResponseDTO: Codable {
    let agendaId: Int
    let agendaOrder: Int
    let agendaName: String
    var agendaResult: String?
}

extension AgendaTodayResponseDTO {
    func toDomain() -> AgendaToday {
        return .init(agendaId: agendaId,
                     agendaOrder: agendaOrder,
                     agendaName: agendaName,
                     agendaResult: agendaResult)
    }
}
