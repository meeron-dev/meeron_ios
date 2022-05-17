//
//  AllCalendarRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/13.
//

import Foundation
import Alamofire
import RxSwift

class AllCalendarRepository {
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
    
    func loadAllCalendarYearMeetingCount(type:CalendarType) -> Observable<AllCalendarYearMeetingCount?> {
        let resource = Resource<AllCalendarYearMeetingCount>(url: "\(URLConstant.allCalendarYearMeeting)?type=\(type)&id=\(getId(type: type))", parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return API.requestData(resource: resource)
    }
    
    func loadAllCalendarMonthMeetingCount(type:CalendarType, year:String) -> Observable<AllCalendarMonthMeetingCount?>{
        let resource = Resource<AllCalendarMonthMeetingCount>(url: "\(URLConstant.allCalendarMonthMeeting)?type=\(type)&id=\(getId(type: type))&year=\(year)", parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return API.requestData(resource: resource)
    }
}
