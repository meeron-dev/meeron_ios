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
    
    let headers:HTTPHeaders = [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)]
    
    
    func createMeeting(data:MeetingCreation) -> Observable<MeetingId?> {
        let meetingAdminIds = data.managers.map{ $0.workspaceUserId }
         
        let parameter:[String:Any] = ["workspaceId": Int(UserDefaults.standard.string(forKey: "workspaceId")!)!,
                                      "meetingDate": data.date.toSlashDateString(),
                                      "startTime":data.startTime.toATimeString(),
                                      "endTime":data.endTime.toATimeString(),
                                      "meetingName": data.title,
                                      "meetingPurpose":data.purpose,
                                      "operationTeamId": data.team!.teamId,
                                      "meetingAdminIds":meetingAdminIds]
        
        print("회의 생성 파라미터",parameter)
        let resource = Resource<MeetingId>(url: URLConstant.meetings, parameter: parameter, headers: headers, method: .post, encodingType: .JSONEncoding)
        
        return  API.requestData(resource: resource)
    }
    
    func createMeetingParticipant(data:MeetingCreation, meetingId:String) -> Observable<Bool> {
        
        let parameter = ["workspaceUserIds":data.participants.map{$0.workspaceUserId}]
        let resource = Resource<Bool>(url: URLConstant.meetings + "/" + meetingId + "/attendees" , parameter: parameter, headers: headers, method: .post, encodingType: .JSONEncoding)
        print("참가자 생성", parameter)
        return  API.requestResponse(resource: resource)
    }
    
    func createMeetingAgenda(datas:[AgendaCreation], meetingId:String) -> Observable<AgendaIds?> {
        var agendas:[Any] = []
        for i in 0..<datas.count {
            var issues:[[String:String]] = []
            for j in 0..<datas[i].issue.count {
                if datas[i].issue[j] != "" {
                    issues.append(["issue":datas[i].issue[j]])
                }
            }
            var agenda:[String:Any] = [:]
            if datas[i].title != "" {
                agenda = ["order":i+1, "name":datas[i].title, "issues":issues]
                agendas.append(agenda)
            }
            
        }
        
        let parameter = ["agendas":agendas]
        print("아젠다",parameter)
        let resource = Resource<AgendaIdsResponseDTO>(url: URLConstant.meetings + "/" + meetingId + "/agendas", parameter: parameter, headers: headers, method: .post, encodingType: .JSONEncoding)
        return  API.requestData(resource: resource)
            .map{$0?.toDomain()}
    }
    
    func createMeetingDocument(data:Data, fileName:String, agendaId:String) -> Observable<Bool> {
        let resource = Resource<Bool>(url: "\(URLConstant.meetingAgenda)/\(agendaId)/files", parameter: [:], headers: ["Content-Type": "multipart/form", "Authorization": "Bearer " + KeychainManager().read(service: "Meeron", account: "accessToken")!], method: .post, encodingType: .URLEncoding)
        
        var mimeType = ""
        if fileName.split(separator: ".")[1] ==  "png" {
            mimeType = "image/png"
        }else if fileName.split(separator: ".")[1] == "pdf" {
            mimeType = "application/pdf"
        }else if fileName.split(separator: ".")[1] == "text" {
            mimeType = "text/plain"
        }
        return API.upload(resource: resource, data: data, fileName: fileName, mimeType: mimeType)
    }
}
