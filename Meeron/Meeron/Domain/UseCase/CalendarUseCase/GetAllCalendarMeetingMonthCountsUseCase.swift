//
//  GetAllCalendarMeetingMonthCountsUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/07/08.
//

import Foundation
import RxSwift

class GetAllCalendarMeetingMonthCountsUseCase {
    let allCalendarRepository = DefaultAllCalendarRepository()
    func execute(type: CalendarType, year: String) -> Observable<[AllCalendarMeetingMonthCount]?> {
        return allCalendarRepository.getAllCalendarMeetingMonthCounts(type: type, year: year)
    }
}
