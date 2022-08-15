//
//  AllCalendarMeetingYearCountsResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/06/01.
//

import Foundation

struct AllCalendarMeetingYearCountsResponseDTO: Codable {
    let yearCounts:[AllCalendarMeetingYearCountResponseDTO]
}

extension AllCalendarMeetingYearCountsResponseDTO {
    func toDomain() -> [AllCalendarMeetingYearCount] {
        return yearCounts.map{$0.toDomain()}
    }
}
