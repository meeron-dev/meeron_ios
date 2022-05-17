//
//  CalendarRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/13.
//

import Foundation
import RxSwift
import Alamofire

class CalendarRepository {
    
    let headers:HTTPHeaders = [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)]
    
    func getId(type:CalendarType) -> String {
        switch type {
        case .workspace:
            return UserDefaults.standard.string(forKey: "workspaceId")!
        case .team:
            return UserDefaults.standard.string(forKey: "workspaceId")!
        case .user:
            return UserDefaults.standard.string(forKey: "workspaceId")!
        }
    }
    
    func loadMeetingDatesInMonth(date:String, type:CalendarType) -> Observable<MeetingDays?> {
    
        let resource = Resource<MeetingDays>(url: "\(URLConstant.calendarMeetingDays)?date=\(date)&type=\(type)&id=\(getId(type: type))", parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return API.requestData(resource: resource)
    }
    
    func loadMeetingOnDate(date:String, type:CalendarType) -> Observable<CalendarMeetings?> {
        
        let urlString = "\(URLConstant.calendarMeeting)?date=\(date)&type=\(type)&id=\(getId(type: type))"
        let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        let resource = Resource<CalendarMeetings>(url: encodedURLString!, parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return API.requestData(resource: resource)
    }
}
