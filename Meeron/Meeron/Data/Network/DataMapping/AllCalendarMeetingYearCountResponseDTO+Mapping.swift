//
//  AllCalendarMeetingYearCountResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/06/01.
//

import Foundation

struct AllCalendarMeetingYearCountResponseDTO: Codable {
    let year:Int
    let count:Int
}

extension AllCalendarMeetingYearCountResponseDTO {
    func toDomain() -> AllCalendarMeetingYearCount {
        return .init(year: year,
                     count: count)
    }
}
