//
//  MeetingCreationRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/10.
//

import Foundation
import RxSwift
import Alamofire

class MeetingCreationRepository {
    
    
    func createMeeting(data:MeetingCreation) -> Observable<Meeting?> {
        let meetingAdminIds = data.managers.map{ $0.workspaceUserId }
        var parameter:[String:Any] = [:]
        if meetingAdminIds.count > 0 {
            parameter = ["meetingDate": data.date.changeMeetingCreationDateToDashString(),
                         "startTime":data.startTime.changeMeetingCreationTimeToString(),
                         "endTime":data.endTime.changeMeetingCreationTimeToString(),
                         "meetingName": data.title,
                         "meetingPurpose":data.purpose,
                         "operationTeamId": data.team!.teamId,
                         "meetingAdminIds":meetingAdminIds]
        }else {
            parameter = ["meetingDate": data.date.changeMeetingCreationDateToDashString(),
                         "startTime":data.startTime.changeMeetingCreationTimeToString(),
                         "endTime":data.endTime.changeMeetingCreationTimeToString(),
                         "meetingName": data.title,
                         "meetingPurpose":data.purpose,
                         "operationTeamId": data.team!.teamId]
        }
        print("회의 생성 파라미터",parameter)
        let resource = Resource<Meeting>(url: URLConstant.meetingCreation, parameter: parameter, headers: ["Content-Type": "application/json","Authorization": "Bearer " + KeychainManager().read(service: "Meeron", account: "accessToken")!], method: .post, encodingType: .JSONEncoding)
        
        return  API().load(resource: resource)
    }
    
    func createMeetingParticipant(data:MeetingCreation, meetingId:String) -> Observable<Bool> {
        
        let parameter = ["workspaceUserIds":data.participants.map{$0.workspaceUserId}]
        let resource = Resource<Bool>(url: URLConstant.meetingCreation + "/" + meetingId + "/attendees" , parameter: parameter, headers: ["Content-Type":"application/json", "Authorization":KeychainManager().read(service: "Meeron", account: "accessToken")!], method: .post, encodingType: .JSONEncoding)
        print("참가자 생성", parameter)
        return  API().requestResponse(resource: resource)
    }
    
    func createMeetingAgenda(datas:[Agenda], meetingId:String) -> Observable<Bool> {
        var agendas:[Any] = []
        for i in 0..<datas.count {
            var issues:[[String:String]] = []
            for j in 0..<datas[i].issue.count {
                issues.append(["issue":datas[i].issue[j]])
            }
            let agenda:[String:Any] = ["order":i+1, "name":datas[i].title, "issues":issues]
            agendas.append(agenda)
        }
        
        let parameter = ["agendas":agendas]
        print("아젠다",parameter)
        let resource = Resource<Bool>(url: URLConstant.meetingCreation + "/" + meetingId + "/agendas", parameter: parameter, headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .post, encodingType: .JSONEncoding)
        return  API().requestResponse(resource: resource)
    }
    
    
}
