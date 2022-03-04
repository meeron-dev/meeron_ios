//
//  Date+DateString.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/02.
//

import Foundation

extension Date {
    func toMeetingCreationDateFormatString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        return dateFormatter.string(from: self)
    }
    
}
