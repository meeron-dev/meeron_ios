//
//  WorkspaceRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/27.
//

import Foundation
import RxSwift

class WorkspaceRepository {
    
    func fetchWorkspaceInfo() -> Observable<Workspace?> {
        
        guard let workspaceId = UserDefaults.standard.string(forKey: "workspaceId") else {return Observable.just(nil)}
        
        let resource = Resource<WorkspaceResponseDTO>(url: URLConstant.workspace+"/\(workspaceId)", parameter: [:], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
        return API.requestData(resource: resource)
            .map{$0?.toDomain()}
    }
    
    func saveWorkspace(data:Workspace) {
        UserDefaults.standard.set(data.workspaceName, forKey: "workspaceName")
    }
}
