//
//  Calendar.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/13.
//

import Foundation

struct MeetingDays:Codable {
    let days:[Int]
}

struct CalendarMeetings:Codable {
    let meetings:[CalendarMeeting]?
}

struct CalendarMeeting:Codable {
    let meetingId: Int
    let meetingName: String
    let startTime: String
    let endTime: String
    var workspaceId: Int?
    var workspaceName: String?
}

struct MeetingDate {
    var date:String
    var hasMeeting:Bool
}
