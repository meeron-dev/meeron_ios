//
//  AllCalendarMeetingMonthCountsResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/07/08.
//

import Foundation
struct AllCalendarMeetingMonthCountsResponseDTO: Codable {
    let monthCounts: [AllCalendarMeetingMonthCountResponseDTO]
}

extension AllCalendarMeetingMonthCountsResponseDTO {
    func toDomain() -> [AllCalendarMeetingMonthCount] {
        return monthCounts.map{$0.toDomain()}
    }
}
