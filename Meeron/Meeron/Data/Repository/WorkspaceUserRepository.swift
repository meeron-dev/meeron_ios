//
//  WorkspaceUserRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/07.
//

import Foundation
import RxSwift

class WorkspaceUserRepository {
    func loadWorkspaceUser(id:Int) -> Observable<User?> {
        let resource = Resource<User>(url: URLConstant.workspaceUsers+"/\(id)/user", parameter: [:], headers: [ "Authorization": "Bearer " + KeychainManager().read(service: "Meeron", account: "accessToken")!], method: .get, encodingType: .URLEncoding)
        
        return API.requestData(resource: resource)
    }
    
    func getUserInWorkspace(nickname:String) -> Observable<[WorkspaceUser]?> {
        let workspaceId = UserDefaults.standard.string(forKey: "workspaceId")!
        
        let urlString = URLConstant.workspaceUsers+"?workspaceId="+workspaceId+"&nickname="+nickname
        let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        
        guard let encodedURLString = encodedURLString else {
            return Observable.just(nil)
        }

        let resource = Resource<WorkspaceUsersResponseDTO>(url:encodedURLString, parameter: [:], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
    
        return API.requestData(resource: resource)
            .map{$0?.toDomain()}
    }
}
