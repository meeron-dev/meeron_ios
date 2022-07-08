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
    
    let yearMeetingCountSubject = BehaviorSubject<[AllCalendarMeetingYearCount]>(value: [])
    let monthMeetingCountSubject = BehaviorSubject<[AllCalendarMeetingMonthCount]>(value: [])
    
    let getAllCalendarMeetingYearCountsUseCase = GetAllCalendarMeetingYearCountsUseCase()
    let getAllCalendarMeetingMonthCountsUseCase = GetAllCalendarMeetingMonthCountsUseCase()
    
    var calendarType:CalendarType!
    
    let disposeBag = DisposeBag()
    
    init(type:CalendarType, nowYear:String, nowMonth:String) {
        calendarType = type
        self.nowYear = nowYear
        self.nowMonth = nowMonth
        loadYearMeetingCount()
    }
    
    func loadYearMeetingCount() {
        getAllCalendarMeetingYearCountsUseCase
            .getAllCalendarMeetingYearCounts(type: calendarType)
            .withUnretained(self)
            .subscribe(onNext: { owner, allCalendarMeetingYearCounts in
                
                if let allCalendarMeetingYearCounts = allCalendarMeetingYearCounts {
                    if !allCalendarMeetingYearCounts.map({ $0.year}).contains(Int(owner.nowYear!)!) {
                        owner.nowYear = Date().toYearString()
                        owner.nowMonth = Date().toMonthString()
                    }
                    owner.yearMeetingCountSubject.onNext(allCalendarMeetingYearCounts)
                    owner.loadMonthMeetingCount()
                }
            }).disposed(by: disposeBag)
    }
    
    func loadMonthMeetingCount() {
        getAllCalendarMeetingMonthCountsUseCase
            .getAllCalendarMeetingMonthCounts(type: calendarType, year: nowYear)
            .withUnretained(self)
            .subscribe(onNext: { owner, allCalendarMonthMeetingCounts in
                if let allCalendarMonthMeetingCounts = allCalendarMonthMeetingCounts {
                    owner.monthMeetingCountSubject.onNext(allCalendarMonthMeetingCounts)
                }
                
            }).disposed(by: disposeBag)
    }
}
