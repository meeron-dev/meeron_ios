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
}
