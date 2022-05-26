//
//  TodayMeetingResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/26.
//

import Foundation

struct TodayMeetingResponseDTO: Codable {
    let meeting:MeetingResponseDTO
    let team:TeamResponseDTO
    let agendas:[AgendaTodayResponseDTO]
    let admins:[MyWorkspaceUserResponseDTO]
    let attendCount:AttendCountResponseDTO
}

extension TodayMeetingResponseDTO {
    func toDomain() -> TodayMeeting {
        return .init(meeting: meeting.toDomain(),
                     team: team.toDomain(),
                     agendas: agendas.map{$0.toDomain()},
                     admins: admins.map{ $0.toDomain()},
                     attendCount: attendCount.toDomain())
    }
}
