//
//  CalendarViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/24.
//

import Foundation
import RxSwift

enum CalendarType:String {
    case workspace = "workspace"
    case team = "team"
    case user = "workspace_user"
}

class CalendarViewModel {
    
    let dateFormatter = DateFormatter()
    var calendar = Calendar.current
    var dateComponents = DateComponents()
    
    let yearSubject = PublishSubject<String>()
    let monthSubject = PublishSubject<String>()
    let daysSubject = PublishSubject<[MeetingDate?]>()
    let calendarHeightSubject = PublishSubject<CGFloat>()
    
    let selectedDateSubject = BehaviorSubject<String>(value: Date().toSlashDateString())
    let selectedDateMeetingsSubject = BehaviorSubject<[CalendarMeeting]>(value: [])
    
    var nowMonthMeetingDates:[Int] = []
    
    let yearMonthSubject = PublishSubject<String>()
    
    let calendarRepository = CalendarRepository()
    
    let calendarType:CalendarType
    
    let disposeBag = DisposeBag()
    
    init(type:CalendarType) {
        calendarType = type
        selectedDateSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                owner.selectedDateMeetings(date: date)
                
            }).disposed(by: disposeBag)
    }
    
    func selectedDateMeetings(date:String) {
        calendarRepository.loadMeetingOnDate(date: date, type: calendarType)
            .withUnretained(self)
            .subscribe(onNext: { owner, calendarMeetings in
                if let calendarMeetings = calendarMeetings {
                    owner.selectedDateMeetingsSubject.onNext(calendarMeetings.meetings)
                }
                
            }).disposed(by: disposeBag)
    }
  
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
        
        dateFormatter.dateFormat = "yyyy/MM"
        let yearMonth = dateFormatter.string(from: firstDayOfMonth!)
        
        
        calendarRepository.loadMeetingDatesInMonth(date: dateFormatter.string(from: firstDayOfMonth!), type: calendarType)
            .withUnretained(self)
            .subscribe(onNext: { owner, dates in
                if let dates = dates {
                    owner.calulateDays(weekdayAdding:weekdayAdding, daysCountInMonth:daysCountInMonth, yearMonth: yearMonth, meetingDates: dates.days)
                }
            }).disposed(by: disposeBag)
    
    }
    
    func calulateDays(weekdayAdding:Int, daysCountInMonth:Int, yearMonth:String, meetingDates:[Int]) {
        var days:[MeetingDate?] = []
        for day in weekdayAdding...daysCountInMonth{
            if day < 1{
                days.append(nil)
            }else{
                day > 9 ? days.append(MeetingDate(date: yearMonth+"/"+String(day), hasMeeting: meetingDates.contains(day))) : days.append(MeetingDate(date: yearMonth+"/"+"0"+String(day), hasMeeting: meetingDates.contains(day)))
                
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
