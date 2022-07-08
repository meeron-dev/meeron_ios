//
//  CalendarRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/07/08.
//

import Foundation
import RxSwift

protocol CalendarRepository {
    
    func getCalendarId(type:CalendarType) -> String
    func getCalendarMeetingDays(date:String, type:CalendarType) -> Observable<CalendarMeetingDays?>
    func getCalendarMeetings(date:String, type:CalendarType) -> Observable<[CalendarMeeting]?>
    
}
