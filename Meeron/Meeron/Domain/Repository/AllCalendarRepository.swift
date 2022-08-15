//
//  AllCalendarRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/07/08.
//

import Foundation
import RxSwift

protocol AllCalendarRepository {
    
    func getAllCalendarMeetingYearCounts(type:CalendarType) -> Observable<[AllCalendarMeetingYearCount]?>
    func getAllCalendarMeetingMonthCounts(type:CalendarType, year:String) -> Observable<[AllCalendarMeetingMonthCount]?>
}
