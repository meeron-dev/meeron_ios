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
        var meetingAdminIds = data.managers.map{ $0.workspaceUserId }
        meetingAdminIds.append(Int(UserDefaults.standard.string(forKey: "workspaceUserId")!)!)
        let parameter:[String:Any] = ["meetingDate": data.date.changeMeetingCreationDateToSlashString(),
                         "startTime":data.startTime.changeMeetingCreationTimeToAString(),
                         "endTime":data.endTime.changeMeetingCreationTimeToAString(),
                         "meetingName": data.title,
                         "meetingPurpose":data.purpose,
                         "operationTeamId": data.team!.teamId,
                         "meetingAdminIds":meetingAdminIds]
        
        print("회의 생성 파라미터",parameter)
        let resource = Resource<Meeting>(url: URLConstant.meetingCreation, parameter: parameter, headers: ["Content-Type": "application/json","Authorization": "Bearer " + KeychainManager().read(service: "Meeron", account: "accessToken")!], method: .post, encodingType: .JSONEncoding)
        
        return  API().requestData(resource: resource)
    }
    
    func createMeetingParticipant(data:MeetingCreation, meetingId:String) -> Observable<Bool> {
        
        let parameter = ["workspaceUserIds":data.participants.map{$0.workspaceUserId}]
        let resource = Resource<Bool>(url: URLConstant.meetingCreation + "/" + meetingId + "/attendees" , parameter: parameter, headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .post, encodingType: .JSONEncoding)
        print("참가자 생성", parameter)
        return  API().requestResponse(resource: resource)
    }
    
    func createMeetingAgenda(datas:[Agenda], meetingId:String) -> Observable<MeetingCreationAgendaResponses?> {
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
        let resource = Resource<MeetingCreationAgendaResponses>(url: URLConstant.meetingCreation + "/" + meetingId + "/agendas", parameter: parameter, headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .post, encodingType: .JSONEncoding)
        return  API().requestData(resource: resource)
    }
    
    func createMeetingDocument(data:Data, agendaId:String) -> Observable<Bool> {
        let resource = Resource<Bool>(url: "\(URLConstant.meetingAgenda)/\(agendaId)/files", parameter: [:], headers: ["Content-Type": "multipart/form-data", "Authorization": "Bearer " + KeychainManager().read(service: "Meeron", account: "accessToken")!], method: .post, encodingType: .URLEncoding)
        
        return API().upload(resource: resource, data: data)
    }
}
