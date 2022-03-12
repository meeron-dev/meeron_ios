//
//  Date+DateString.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/02.
//

import Foundation

extension Date {
    func changeMeetingCreationDateToKoreanString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        return dateFormatter.string(from: self)
    }
    
    func changeMeetingCreationTimeToAString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    func changeMeetingCreationDateToSlashString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: self)
    }
    
}
