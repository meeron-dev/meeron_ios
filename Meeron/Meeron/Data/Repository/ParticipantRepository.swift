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

    let headers:HTTPHeaders = [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)]
    
    func loadParticipantsCountByTeam(meetingId:Int) -> Observable<[ParticipantCountByTeam]?> {
        let resource = Resource<ParticipantCountsByTeamResponseDTO>(url: URLConstant.meetings+"/\(meetingId)/attendees/teams", parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return API.requestData(resource: resource)
            .map{$0?.toDomain()}
    }
    
    func loadParticipantCountInfo(teamId:Int, meetingId:Int) -> Observable<ParticipantInfo?> {
        let resource = Resource<ParticipantInfoResponseDTO>(url: URLConstant.meetings+"/\(meetingId)/attendees/teams/\(teamId)", parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return API.requestData(resource: resource)
            .map{$0?.toDomain()}
    }
    
    func patchParicipantStatus(meetingId:Int, status:ParicipantStatusType) -> Observable<Bool> {
        
        guard let workspaceUserId = UserDefaults.standard.string(forKey: "workspaceUserId") else {return Observable.just(false)}
        
        let resource = Resource<Bool>(url: URLConstant.attendees+"/\(workspaceUserId)", parameter: ["meetingId":meetingId, "status":status.rawValue], headers: headers, method: .patch, encodingType: .JSONEncoding)
        return API.requestResponse(resource: resource)
    }


}
