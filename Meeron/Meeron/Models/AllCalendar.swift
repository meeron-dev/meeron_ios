//
//  AllCalendar.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/13.
//

import Foundation

struct AllCalendarYearMeetingCount:Codable {
    let yearCounts:[YearMeetingCount]
}

struct YearMeetingCount:Codable {
    let year:Int
    let count:Int
}

struct AllCalendarMonthMeetingCount:Codable {
    let monthCounts:[MonthMeetingCount]
}

struct MonthMeetingCount:Codable {
    let month:Int
    let count:Int
}
