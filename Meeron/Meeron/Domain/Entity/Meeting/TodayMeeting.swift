//
//  TodayMeeting.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/26.
//

import Foundation

struct TodayMeeting {
    let meeting:Meeting
    let team:Team
    let agendas:[AgendaToday]
    let admins:[MyWorkspaceUser]
    let attendCount:AttendCount
}
