//
//  URLConstant.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/28.
//

import Foundation

struct URLConstant {
    static let protocolHost = "https://dev.meeron.net"
    
    static let reissue = protocolHost + "/api/reissue"
    static let login = protocolHost + "/api/login"
    static let user = protocolHost + "/api/users/me"
    static let userName = protocolHost + "/api/users/name"
    
    static let todayMeeting = protocolHost + "/api/meetings/today"
    
    // Calendar
    static let calendarMeetingDays = protocolHost + "/api/meetings/days"
    static let calendarMeeting = protocolHost + "/api/meetings/day"
    static let allCalendarYearMeeting = protocolHost + "/api/meetings/years"
    static let allCalendarMonthMeeting = protocolHost + "/api/meetings/months"
    
    
    static let userWorkspace = protocolHost + "/api/users"
    static let workspaceUserProfile = protocolHost + "/api/workspace-users"
    static let teamInWorkspace = protocolHost + "/api/teams"
    static let meetingCreation = protocolHost + "/api/meetings"
    static let meetingAgenda = protocolHost + "/api/agendas"
    
    static let workspace = protocolHost + "/api/workspaces"
    static let workspaceUsers = protocolHost + "/api/workspace-users"
    
    static let terms = "https://ryuyxxn.notion.site/29115494f9324509ba21416bbb1c7ef1"
    static let personalInformationCollection = "https://ryuyxxn.notion.site/502b6e5487664faab875f7b4e5383a7b"
    
    
    
}
