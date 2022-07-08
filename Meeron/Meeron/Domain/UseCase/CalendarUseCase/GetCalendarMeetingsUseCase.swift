//
//  GetCalendarMeetingsUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/06/01.
//

import Foundation
import RxSwift

class GetCalendarMeetingsUseCase {
    let calendarRepository = CalendarRepository()
    
    func execute(date:String, type: CalendarType) -> Observable<[CalendarMeeting]?> {
        return calendarRepository.getCalendarMeetings(date: date, type: type)
    }
}
