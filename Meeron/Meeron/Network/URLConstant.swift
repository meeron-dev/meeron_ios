//
//  URLConstant.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/28.
//

import Foundation

struct URLConstant {
    static let protocolHost = "https://dev.meeron.net"
    
    static let login = protocolHost + "/api/login"
    static let user = protocolHost + "/api/users/me"
    static let userWorkspace = protocolHost + "/api/users/1/workspace-users"
    static let workspaceUserProfile = protocolHost + "/api/workspace-users"
    static let teamInWorkspace = protocolHost + "/api/teams"
    static let meetingCreation = protocolHost + "/api/meetings"
    static let meetingAgenda = protocolHost + "/api/agendas"
    static let todayMeeting = protocolHost + "/api/meetings/today"
    static let calendarMeeting = protocolHost + "/api/meetings/days"
    static let allCalendarYearMeeting = protocolHost + "/api/meetings/years"
    static let allCalendarMonthMeeting = protocolHost + "/api/meetings/months"
    
}
