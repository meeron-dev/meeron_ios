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
    let meeting:Meeting
    let team:TeamToday
    let agendas:[AgendaToday]
    let admins:[AdminToday]
    let attendCount:AttendCount
}

struct Meeting:Codable {
    let meetingId: Int
    let startDate: String
    let startTime: String
    let endTime: String
    let meetingName: String
    let purpose: String
    let place: String?
}

struct TeamToday:Codable {
    let teamId: Int
    let teamName: String
}

struct AgendaToday:Codable {
    let agendaId: Int
    let agendaOrder: Int
    let agendaName: String
    var agendaResult: String?
}

struct AdminToday:Codable{
    let workspaceUserId: Int
    let nickname: String
    let position: String
    let profileImageUrl: String?
    let email: String?
    let phone: String?
    let workspaceAdmin: Bool
}
struct AttendCount:Codable {
    let attend: Int
    let absent: Int
    let unknown: Int
}

struct MeetingBasicInfo:Codable {
    let meetingId:Int
    let meetingName:String
    let meetingPurpose:String
    let meetingDate:String
    let startTime:String
    let endTime:String
    let operationTeamId: Int
    let operationTeamName: String
    let admins: [Admin]
}

struct Admin:Codable {
    let workspaceUserId: Int
    let nickname: String
}

struct AgendaCountInfo:Codable {
    let agendas: Int
    let checks: Int
    let files: Int
}
