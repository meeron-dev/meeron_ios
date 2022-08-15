//
//  GetCalendarMeetingDaysUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/06/01.
//

import Foundation
import RxSwift

class GetCalendarMeetingDaysUseCase {
    let calendarRepository = DefaultCalendarRepository()
    func execute(date:String, type:CalendarType) -> Observable<CalendarMeetingDays?> {
        return calendarRepository.getCalendarMeetingDays(date: date, type: type)
    }
}
