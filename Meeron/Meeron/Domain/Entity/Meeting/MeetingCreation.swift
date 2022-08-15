//
//  MeetingCreation.swift
//  Meeron
//
//  Created by 심주미 on 2022/08/16.
//

import Foundation

struct MeetingCreation {
    var date:Date = Date()
    var startTime:Date = Date()
    var endTime:Date = Date()
    var title:String = ""
    var purpose:String = ""
    var managers:[WorkspaceUser] = []
    var team:Team?
    var agendas:[AgendaCreation] = []
    var participants:[WorkspaceUser] = []
    
    var meetingId:String = ""
}
