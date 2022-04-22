//
//  AllCalendarViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/15.
//

import Foundation
import RxSwift

class AllCalendarViewModel {
    var nowYear:String!
    var nowMonth:String!
    
    let yearMeetingCountSubject = BehaviorSubject<[YearMeetingCount]>(value: [])
    let monthMeetingCountSubject = BehaviorSubject<[MonthMeetingCount]>(value: [])
    
    let allCalendarRepository = AllCalendarRepository()
    
    var calendarType:CalendarType!
    
    let disposeBag = DisposeBag()
    
    init(type:CalendarType, nowYear:String, nowMonth:String) {
        calendarType = type
        self.nowYear = nowYear
        self.nowMonth = nowMonth
        loadYearMeetingCount()
    }
    
    func loadYearMeetingCount() {
        allCalendarRepository.loadAllCalendarYearMeetingCount(type: calendarType)
            .withUnretained(self)
            .subscribe(onNext: { owner, allCalendarYearMeetingCount in
                
                if let allCalendarYearMeetingCount = allCalendarYearMeetingCount {
                    if !allCalendarYearMeetingCount.yearCounts.map({ $0.year}).contains(Int(owner.nowYear!)!) {
                        owner.nowYear = Date().toYearString()
                        owner.nowMonth = Date().toMonthString()
                    }
                    owner.yearMeetingCountSubject.onNext(allCalendarYearMeetingCount.yearCounts)
                    owner.loadMonthMeetingCount()
                }
            }).disposed(by: disposeBag)
    }
    
    func loadMonthMeetingCount() {
        allCalendarRepository.loadAllCalendarMonthMeetingCount(type: calendarType, year: nowYear)
            .withUnretained(self)
            .subscribe(onNext: { owner, allCalendarMonthMeetingCount in
                if let allCalendarMonthMeetingCount = allCalendarMonthMeetingCount {
                    owner.monthMeetingCountSubject.onNext(allCalendarMonthMeetingCount.monthCounts)
                }
                
            }).disposed(by: disposeBag)
    }
}
