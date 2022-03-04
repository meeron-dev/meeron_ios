//
//  CalendarViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/24.
//

import Foundation
import RxSwift

class CalendarViewModel {
    
    let dateFormatter = DateFormatter()
    var calendar = Calendar.current
    var dateComponents = DateComponents()
    
    var yearSubject = PublishSubject<String>()
    var monthSubject = PublishSubject<String>()
    var daysSubject = PublishSubject<[String?]>()
    var calendarHeightSubject = PublishSubject<CGFloat>()
    
  
    func initDate() {
        let now = Date()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateComponents.year = calendar.component(.year, from: now)
        dateComponents.month = calendar.component(.month, from: now)
        dateComponents.day = 1
        calculateDate()
    }
    
    private func calculateDate(){
        let firstDayOfMonth = calendar.date(from: dateComponents)
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth!)
        let daysCountInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        let weekdayAdding = 2-firstWeekday
        
        dateFormatter.dateFormat = "yyyy"
        yearSubject.onNext(dateFormatter.string(from: firstDayOfMonth!))
        dateFormatter.dateFormat = "M월"
        monthSubject.onNext(dateFormatter.string(from: firstDayOfMonth!))
        
        dateFormatter.dateFormat = "yyyy-MM-"
        let yearMonth = dateFormatter.string(from: firstDayOfMonth!)
        
        var days:[String?] = []
        for day in weekdayAdding...daysCountInMonth{
            if day < 1{
                days.append(nil)
            }else{
                day > 9 ? days.append(yearMonth+String(day)) : days.append(yearMonth+"0"+String(day))
            }
        }
        daysSubject.onNext(days)
        calendarHeightSubject.onNext(CGFloat(ceil(Double(days.count)/7.0)*44))
    
    }
    
    func prevMonth() {
        dateComponents.month = dateComponents.month! - 1
        calculateDate()
    }
    
    func nextMonth() {
        dateComponents.month = dateComponents.month! + 1
        calculateDate()
    }
}
