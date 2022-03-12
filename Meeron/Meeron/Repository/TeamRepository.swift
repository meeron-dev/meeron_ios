//
//  TeamRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/09.
//

import Foundation
import RxSwift

class TeamRepository {
    
    func loadTeamInWorkspace() -> Observable<Teams?> {
        guard let workspaceId = UserDefaults.standard.string(forKey: "workspaceId") else {return Observable.of(nil)}
        let urlString = URLConstant.teamInWorkspace+"?workspaceId="+workspaceId
        let resource = Resource<Teams>(url:urlString, parameter: [:], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
        
        return API().requestData(resource: resource)
    }
    
    func loadUsersInWorkspaceTeam(teamId:String) -> Observable<WorkspaceUserProfiles?> {
        
        let resource = Resource<WorkspaceUserProfiles>(url:URLConstant.teamInWorkspace+"/"+teamId+"/workspace-users", parameter: ["teamId":teamId], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
        
        return API().requestData(resource: resource)
    }
}
