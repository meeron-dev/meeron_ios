//
//  TodayMeeting.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/12.
//

import Foundation

struct TodayMeetings:Codable {
    let meetings:[TodayMeeting]
}

struct TodayMeeting:Codable {
    let meetingId: Int
    let meetingName: String
    let meetingDate: String
    let startTime: String
    let endTime: String
    let operationTeamId: Int
    let operationTeamName: String
    let meetingStatus: String
}
