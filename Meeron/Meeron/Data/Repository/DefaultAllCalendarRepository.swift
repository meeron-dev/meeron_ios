//
//  DefaultAllCalendarRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/13.
//

import Foundation
import Alamofire
import RxSwift

class DefaultAllCalendarRepository: AllCalendarRepository {
    let headers:HTTPHeaders = [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)]
    
    let calendarRepository = DefaultCalendarRepository()
    
    func getAllCalendarMeetingYearCounts(type:CalendarType) -> Observable<[AllCalendarMeetingYearCount]?> {
        let calendarId = calendarRepository.getCalendarId(type: type)
        let resource = Resource<AllCalendarMeetingYearCountsResponseDTO>(url: "\(URLConstant.allCalendarYearMeeting)?type=\(type)&id=\(calendarId)", parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return API.requestData(resource: resource)
            .map{$0?.toDomain()}
    }
    
    func getAllCalendarMeetingMonthCounts(type:CalendarType, year:String) -> Observable<[AllCalendarMeetingMonthCount]?>{
        let calendarId = calendarRepository.getCalendarId(type: type)
        let resource = Resource<AllCalendarMeetingMonthCountsResponseDTO>(url: "\(URLConstant.allCalendarMonthMeeting)?type=\(type)&id=\(calendarId)&year=\(year)", parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return API.requestData(resource: resource)
            .map{$0?.toDomain()}
    }
}
