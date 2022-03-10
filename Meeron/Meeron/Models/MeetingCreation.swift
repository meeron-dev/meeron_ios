//
//  MeetingCreationInfo.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/02.
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
    var agendas:[Agenda] = []
    var participants:[WorkspaceUser] = []
    
    var meetingId:String = ""
}

struct Agenda {
    var title:String = ""
    var issue:[String] = [""]
    var document:[Data] = []
}
