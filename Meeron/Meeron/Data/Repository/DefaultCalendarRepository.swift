//
//  DefaultCalendarRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/13.
//

import Foundation
import RxSwift
import Alamofire

class DefaultCalendarRepository: CalendarRepository {
    
    let headers:HTTPHeaders = [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)]
    
    func getCalendarId(type:CalendarType) -> String {
        switch type {
        case .workspace:
            return UserDefaults.standard.string(forKey: "workspaceId")!
        case .team:
            return UserDefaults.standard.string(forKey: "workspaceId")!
        case .user:
            return UserDefaults.standard.string(forKey: "workspaceId")!
        }
    }
    
    func getCalendarMeetingDays(date:String, type:CalendarType) -> Observable<CalendarMeetingDays?> {
    
        let resource = Resource<CalendarMeetingDaysResponseDTO>(url: "\(URLConstant.calendarMeetingDays)?date=\(date)&type=\(type)&id=\(getCalendarId(type: type))", parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return API.requestData(resource: resource)
            .map{$0?.toDomain()}
    }
    
    func getCalendarMeetings(date:String, type:CalendarType) -> Observable<[CalendarMeeting]?> {
        
        let urlString = "\(URLConstant.calendarMeeting)?date=\(date)&type=\(type)&id=\(getCalendarId(type: type))"
        let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        let resource = Resource<CalendarMeetingsResponseDTO>(url: encodedURLString!, parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return API.requestData(resource: resource)
            .map{$0?.toDomain()}
    }
}
