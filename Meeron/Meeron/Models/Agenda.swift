//
//  Agenda.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/02.
//

import Foundation

struct Agenda: Codable {
    let agendaId:Int
    let agendaName:String
    let issues:[Issue]
    let files:[File]
}

struct Issue: Codable {
    let issueId:Int
    let content:String
}

struct File: Codable {
    let fileId:Int
    let fileName:String
    let fileUrl:String
}


