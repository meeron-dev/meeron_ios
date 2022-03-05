//
//  MeetingCreationInfo.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/02.
//

import Foundation

struct MeetingCreation {
    var date:Date?
    var startTime:Date?
    var endTime:Date?
}

struct Agenda {
    var title:String = ""
    var issue:[String] = [""]
    var document:[Data] = []
}
