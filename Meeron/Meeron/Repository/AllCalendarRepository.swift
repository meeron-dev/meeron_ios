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
    
    let api = API()
    func loadAllCalendarYearMeetingCount(type:String, id:String) -> Observable<AllCalendarYearMeetingCount?> {
        let resource = Resource<AllCalendarYearMeetingCount>(url: "\(URLConstant.allCalendarYearMeeting)?type=\(type)&id=\(id)", parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return api.requestData(resource: resource)
    }
    
    func loadAllCalendarMonthMeetingCount(type:String, id:String, year:String) -> Observable<AllCalendarMonthMeetingCount?>{
        let resource = Resource<AllCalendarMonthMeetingCount>(url: "\(URLConstant.allCalendarMonthMeeting)?type=\(type)&id=\(id)&year=\(year)", parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return api.requestData(resource: resource)
    }
}
