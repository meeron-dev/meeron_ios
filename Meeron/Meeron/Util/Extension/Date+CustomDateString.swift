//
//  Date+DateString.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/02.
//

import Foundation

extension Date {
    func toKoreanDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        return dateFormatter.string(from: self)
    }
    
    func toATimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: self)
    }
    
    func toSlashDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/d"
        return dateFormatter.string(from: self)
    }
    
    func toMonthDayKoreanString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        return dateFormatter.string(from: self)
    }
    
    func toYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    func toMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        return dateFormatter.string(from: self)
    }
    
    func toYearMonthSlashString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M"
        return dateFormatter.string(from: self)
    }
}
