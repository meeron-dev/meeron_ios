//
//  TeamRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/09.
//

import Foundation
import RxSwift
import Alamofire

class TeamRepository {
    let headers:HTTPHeaders = [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)]
    let api = API()
    
    func getTeamsInWorkspace() -> Observable<[Team]?> {
        guard let workspaceId = UserDefaults.standard.string(forKey: "workspaceId") else {
            return Observable.just(nil)
        }
                
        let urlString = URLConstant.teamInWorkspace+"?workspaceId="+workspaceId
        let resource = Resource<TeamsResponseDTO>(url:urlString, parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return API.requestData(resource: resource)
            .map{$0?.toDomain()}
    }
    
    func getUsersInWorkspaceTeam(teamId:String) -> Observable<[WorkspaceUser]?> {
        
        let resource = Resource<WorkspaceUsersResponseDTO>(url:URLConstant.teamInWorkspace+"/"+teamId+"/workspace-users", parameter: ["teamId":teamId], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return API.requestData(resource: resource)
            .map{$0?.toDomain()}
    }
    
    func getUsersWithoutTeam() -> Observable<[WorkspaceUser]?> {
        
        guard let workspaceId = UserDefaults.standard.string(forKey: "workspaceId") else {
            return Observable.just(nil)
        }
        
        let resource = Resource<WorkspaceUsersResponseDTO>(url: URLConstant.teamInWorkspace+"/none/workspace-users?workspaceId=\(workspaceId)", parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return API.requestData(resource: resource)
            .map{$0?.toDomain()}
    }
    
    func createTeam(name:String) -> Observable<TeamCreationResponse?> {
        guard let workspaceId = UserDefaults.standard.string(forKey: "workspaceId") else {
            return Observable.just(nil)
        }
        let resource = Resource<TeamCreationResponse>(url: URLConstant.teamInWorkspace, parameter: ["workspaceId":workspaceId,"teamName":name], headers: headers, method: .post, encodingType: .JSONEncoding)
        
        return API.requestData(resource: resource)
    }
    
    func createParticipant(teamId:Int, datas:[WorkspaceUser]) -> Observable<Bool>{
        
        var participantIds:[Int] = []
        for data in datas {
            participantIds.append(data.workspaceUserId)
        }
        
        guard let workspaceUserId =  UserDefaults.standard.string(forKey: "workspaceUserId") else {return Observable.just(false)}
        
        let resource = Resource<Bool>(url: URLConstant.teamInWorkspace+"/\(teamId)/workspace-users", parameter: ["adminWorkspaceUserId":workspaceUserId,"joinTeamWorkspaceUserIds":participantIds], headers: headers, method: .patch, encodingType: .JSONEncoding)
        
        return API.requestResponse(resource: resource)
        
    }
    
    func deleteTeam(teamId:Int) -> Observable<Bool> {
        guard let workspaceUserId =  UserDefaults.standard.string(forKey: "workspaceUserId") else {return Observable.just(false)}
        
        let resource = Resource<Bool>(url: URLConstant.teamInWorkspace+"/\(teamId)", parameter: ["adminWorkspaceUserId":workspaceUserId], headers: headers, method: .post, encodingType: .JSONEncoding)
        return API.requestResponse(resource: resource)
    }
    
    func deleteParticipant(data:WorkspaceUser) -> Observable<Bool> {
        guard let workspaceUserId =  UserDefaults.standard.string(forKey: "workspaceUserId") else {return Observable.just(false)}
        
        let resource = Resource<Bool>(url: URLConstant.workspaceUsers+"/\(data.workspaceUserId)/team", parameter: ["adminWorkspaceUserId":workspaceUserId], headers: headers, method: .patch, encodingType: .JSONEncoding)
        
        return API.requestResponse(resource: resource)
    }
    
    func patchNewTeamName(name:String, teamId:Int) {
        guard let workspaceUserId =  UserDefaults.standard.string(forKey: "workspaceUserId") else {return}
        
        
        let resource = Resource<Bool>(url: URLConstant.teamInWorkspace+"/\(teamId)/name", parameter: ["adminWorkspaceUserId":workspaceUserId, "teamName": name], headers: headers, method: .patch, encodingType: .JSONEncoding)
        
        API.requestResponse(resource: resource)
    }
}
