//
//  CalendarMeetingResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/06/01.
//

import Foundation

struct CalendarMeetingResponseDTO: Codable {
    let meetingId: Int
    let meetingName: String
    let startDate: String
    let startTime: String
    let endTime: String
    let purpose: String
    var workspaceId: Int?
    var workspaceName: String?
}

extension CalendarMeetingResponseDTO {
    func toDomain() -> CalendarMeeting {
        return .init(meetingId: meetingId,
                     meetingName: meetingName,
                     startDate: startDate,
                     startTime: startTime,
                     endTime: endTime,
                     purpose: purpose,
                     workspaceId: workspaceId,
                     workspaceName: workspaceName)
    }
}
