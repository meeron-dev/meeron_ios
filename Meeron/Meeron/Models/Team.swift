//
//  Team.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/08.
//

import Foundation

struct Teams:Codable {
    var teams:[Team]
}

struct Team:Codable, Equatable {
    var teamId: Int
    var teamName: String
    var teamOrder:Int?
}

struct TeamCreationResponse:Codable {
    var createdTeamId: Int
}
