//
//  CalendarMeetingsResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/06/01.
//

import Foundation

struct CalendarMeetingsResponseDTO: Codable {
    let meetings:[CalendarMeetingResponseDTO]
}

extension CalendarMeetingsResponseDTO {
    func toDomain() -> [CalendarMeeting] {
        return meetings.map{$0.toDomain()}
    }
}
