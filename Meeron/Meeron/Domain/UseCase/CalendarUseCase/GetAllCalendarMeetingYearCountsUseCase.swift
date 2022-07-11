//
//  GetAllCalendarMeetingYearCountsUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/07/08.
//

import Foundation
import RxSwift

class GetAllCalendarMeetingYearCountsUseCase {
    let allCalendarRepository = DefaultAllCalendarRepository()
    func execute(type: CalendarType) -> Observable<[AllCalendarMeetingYearCount]?> {
        return allCalendarRepository.getAllCalendarMeetingYearCounts(type: type)
    }
}
