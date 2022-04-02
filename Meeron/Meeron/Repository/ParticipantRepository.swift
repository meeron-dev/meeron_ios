//
//  ParticipantRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/02.
//

import Foundation
import Alamofire
import RxSwift

class ParticipantRepository {
    let api = API()
    let headers:HTTPHeaders = [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)]
    
    func loadParticipantsCountByTeam(meetingId:Int) -> Observable<ParticipantCountsByTeam?> {
        let resource = Resource<ParticipantCountsByTeam>(url: URLConstant.meetings+"/\(meetingId)/attendees/teams", parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return api.requestData(resource: resource)
    }
    
    func loadParticipantCountInfo(teamId:Int, meetingId:Int) -> Observable<ParticipantCount?> {
        let resource = Resource<ParticipantCount>(url: URLConstant.meetings+"/\(meetingId)/attendees/teams/\(teamId)", parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return api.requestData(resource: resource)
    }


}
