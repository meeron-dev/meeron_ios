//
//  CalendarMeeting.swift
//  Meeron
//
//  Created by 심주미 on 2022/06/01.
//

import Foundation

struct CalendarMeeting {
    let meetingId: Int
    let meetingName: String
    let startDate: String
    let startTime: String
    let endTime: String
    let purpose: String
    var workspaceId: Int?
    var workspaceName: String?
}
