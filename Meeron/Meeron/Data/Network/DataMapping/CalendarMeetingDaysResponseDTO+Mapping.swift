//
//  CalendarMeetingDaysResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/06/01.
//

import Foundation

struct CalendarMeetingDaysResponseDTO: Codable {
    let days:[Int]
}

extension CalendarMeetingDaysResponseDTO {
    func toDomain() -> CalendarMeetingDays {
        return .init(days: days)
    }
}
