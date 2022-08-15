//
//  AgendaResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/08/16.
//

import Foundation

struct AgendaResponseDTO: Codable {
    let agendaId:Int
    let agendaName:String
    let issues:[IssueResponseDTO]
    let files:[FileResponseDTO]
}

extension AgendaResponseDTO {
    func toDomain() -> Agenda {
        return .init(agendaId: agendaId,
                     agendaName: agendaName,
                     issues: issues.map{$0.toDomain()},
                     files: files.map{$0.toDomain()})
    }
}


