//
//  MeetingRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/12.
//

import Foundation
import RxSwift
import Alamofire

class MeetingRepository {
    
    let headers: HTTPHeaders = [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)]
    
    let api = API()
    
    func loadTodayMeeting() -> Observable<TodayMeetings?> {
        
        guard let worksapceId = UserDefaults.standard.string(forKey: "workspaceId"), let workspaceUserId = UserDefaults.standard.string(forKey: "workspaceUserId") else {return Observable.just(nil)}
        
        let url = "\(URLConstant.todayMeeting)?workspaceId=\(worksapceId)&workspaceUserId=\(workspaceUserId)"
        
        let resource = Resource<TodayMeetings>(url: url, parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return api.requestData(resource: resource)
    }
    
    func loadMeetingBasicInfo(meetingId:Int) -> Observable<MeetingBasicInfo?>{
        let resource = Resource<MeetingBasicInfo>(url: URLConstant.meetings+"/\(meetingId)", parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return api.requestData(resource: resource)
    }
    
}
