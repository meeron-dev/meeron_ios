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
    var calendar = Calendar.current
    var dateComponents = DateComponents()
    
    let yearSubject = PublishSubject<String>()
    let monthSubject = PublishSubject<String>()
    let daysSubject = PublishSubject<[MeetingDate?]>()
    var days:[MeetingDate?] = []
    let calendarHeightSubject = PublishSubject<CGFloat>()
    
    let selectedDateSubject = BehaviorSubject<String>(value: Date().toSlashDateString())
    let selectedDateMeetingsSubject = BehaviorSubject<[CalendarMeeting]>(value: [])
    let selectedDateMeetingCountSubject = BehaviorSubject<Int>(value: 0)
    var selectedDate = Date().toSlashDateString()
    
    var nowMonthMeetingDates:[Int] = []
    var nowMonth:String = Date().toMonthString()
    var nowYear:String = Date().toYearString()
    
    let yearMonthSubject = PublishSubject<String>()
    
    let calendarRepository = CalendarRepository()
    
    let calendarType:CalendarType
    
    let disposeBag = DisposeBag()
    
    init(type:CalendarType) {
        calendarType = type
        selectedDateSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                owner.selectedDate = date
                owner.loadSelectedDateMeetings()
                owner.daysSubject.onNext(owner.days)
            }).disposed(by: disposeBag)
    }
    
    func loadSelectedDateMeetings() {
        calendarRepository.loadMeetingOnDate(date: selectedDate, type: calendarType)
            .withUnretained(self)
            .subscribe(onNext: { owner, calendarMeetings in
                if let calendarMeetings = calendarMeetings?.meetings {
                    owner.selectedDateMeetingsSubject.onNext(calendarMeetings)
                    owner.selectedDateMeetingCountSubject.onNext(calendarMeetings.count)
                }else {
                    owner.selectedDateMeetingsSubject.onNext([])
                    owner.selectedDateMeetingCountSubject.onNext(0)
                }
                
            }).disposed(by: disposeBag)
    }
  
    func initDate() {
        let now = Date()
        dateComponents.year = calendar.component(.year, from: now)
        dateComponents.month = calendar.component(.month, from: now)
        dateComponents.day = 1
        calculateDate()
    }
    
    private func calculateDate(){
        let firstDayOfMonth = calendar.date(from: dateComponents)!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let daysCountInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!.count
        let weekdayAdding = 2-firstWeekday
        
        yearSubject.onNext(firstDayOfMonth.toYearString())
        monthSubject.onNext(firstDayOfMonth.toMonthString() + "월")
        nowYear = firstDayOfMonth.toYearString()
        nowMonth = firstDayOfMonth.toMonthString()
        
        let yearMonth = firstDayOfMonth.toYearMonthSlashString()
        
        calendarRepository.loadMeetingDatesInMonth(date: firstDayOfMonth.toYearMonthSlashString(), type: calendarType)
            .withUnretained(self)
            .subscribe(onNext: { owner, dates in
                if let dates = dates {
                    owner.calulateDays(weekdayAdding:weekdayAdding, daysCountInMonth:daysCountInMonth, yearMonth: yearMonth, meetingDates: dates.days)
                }
            }).disposed(by: disposeBag)
    
    }
    
    private func calulateDays(weekdayAdding:Int, daysCountInMonth:Int, yearMonth:String, meetingDates:[Int]) {
        days = []
        for day in weekdayAdding...daysCountInMonth{
            if day < 1{
                days.append(nil)
            }else{
                days.append(MeetingDate(date: yearMonth+"/"+String(day), hasMeeting: meetingDates.contains(day)))
            }
        }
        
        daysSubject.onNext(days)
        calendarHeightSubject.onNext(CGFloat(ceil(Double(days.count)/7.0)*44))
    }
    
    func prevMonth() {
        dateComponents.month = dateComponents.month! - 1
        calculateDate()
        selectedDateSubject.onNext(calendar.date(from: dateComponents)!.toSlashDateString())
    }
    
    func nextMonth() {
        dateComponents.month = dateComponents.month! + 1
        calculateDate()
        selectedDateSubject.onNext(calendar.date(from: dateComponents)!.toSlashDateString())
    }
    
    func changeDate(newMonth:String, newYear:String) {
        dateComponents.month = Int(newMonth)
        dateComponents.year = Int(newYear)
        calculateDate()
        selectedDateSubject.onNext(calendar.date(from: dateComponents)!.toSlashDateString())
    }
}
