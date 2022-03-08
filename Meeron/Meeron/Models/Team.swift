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

struct Team:Codable {
    var teamId: Int
    var teamName: String
}
