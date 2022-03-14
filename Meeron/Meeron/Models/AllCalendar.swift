//
//  AllCalendar.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/13.
//

import Foundation

struct AllCalendarYearMeetingCount:Codable {
    let yearCounts:[yearCount]
}

struct yearCount:Codable {
    let year:Int
    let count:Int
}

struct AllCalendarMonthMeetingCount:Codable {
    let monthCounts:[MonthCount]
}

struct MonthCount:Codable {
    let month:Int
    let count:Int
}
