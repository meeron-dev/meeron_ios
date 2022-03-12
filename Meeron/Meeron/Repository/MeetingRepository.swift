//
//  MeetingRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/12.
//

import Foundation
import RxSwift

class MeetingRepository {
    func loadTodayMeeting() -> Observable<TodayMeetings?> {
        let url = "\(URLConstant.todayMeeting)?workspaceId=\(UserDefaults.standard.string(forKey: "workspaceId")!)&workspaceUserId=\(UserDefaults.standard.string(forKey: "workspaceUserId")!)"
        
        let resource = Resource<TodayMeetings>(url: url, parameter: [:], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
        
        return API().requestData(resource: resource)
    }
}
