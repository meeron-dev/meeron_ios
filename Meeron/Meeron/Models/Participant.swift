//
//  Participant.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/02.
//

import Foundation

struct ParticipantCountsByTeam:Codable {
    let attendees:[ParticipantCountByTeam]
}

struct ParticipantCountByTeam:Codable {
    let teamId:Int
    let teamName:String
    let attends:Int
    let absents:Int
    let unknowns:Int
}

struct ParticipantCount:Codable {
    let attends:[WorkspaceUser]
    let absents:[WorkspaceUser]
    let unknowns:[WorkspaceUser]
}
