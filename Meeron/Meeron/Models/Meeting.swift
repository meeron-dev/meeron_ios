//
//  Meeting.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/10.
//

import Foundation

struct Meeting: Codable{
    let meetingId:Int
}


struct MeetingCreationAgendaResponses:Codable {
    let createdAgendaIds:[Int]
}

