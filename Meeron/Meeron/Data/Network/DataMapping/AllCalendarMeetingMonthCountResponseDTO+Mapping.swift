//
//  AllCalendarMeetingMonthCountResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/07/08.
//

import Foundation

struct AllCalendarMeetingMonthCountResponseDTO: Codable {
    let month: Int
    let count: Int
}

extension AllCalendarMeetingMonthCountResponseDTO {
    func toDomain() -> AllCalendarMeetingMonthCount{
        return .init(month: month,
                     count: count)
    }
}
