//
//  MeetingResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/26.
//

import Foundation

struct MeetingResponseDTO:Codable {
    let meetingId: Int
    let startDate: String
    let startTime: String
    let endTime: String
    let meetingName: String
    let purpose: String
    let place: String?
}

extension MeetingResponseDTO {
    func toDomain() -> Meeting {
        return .init(meetingId: meetingId,
                     startDate: startDate,
                     startTime: startTime,
                     endTime: endTime,
                     meetingName: meetingName,
                     purpose: purpose,
                     place: place)
    }
}
