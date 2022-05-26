//
//  AgendaToday.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/27.
//

import Foundation

struct AgendaToday:Codable {
    let agendaId: Int
    let agendaOrder: Int
    let agendaName: String
    var agendaResult: String?
}
