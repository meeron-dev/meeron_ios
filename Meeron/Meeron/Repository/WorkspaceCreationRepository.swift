//
//  WorkspaceCreationRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/21.
//

import Foundation
import Alamofire
import RxSwift

class WorkspaceCreationRepository {
    
    let headers:HTTPHeaders = [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)]
    
    let api = API()
    
    func postWorkspaceName(name:String) -> Observable<WorkspaceCreationResponse?> {
        
        let resource = Resource<WorkspaceCreationResponse>(url: URLConstant.workspace, parameter: ["name":name], headers: headers, method: .post, encodingType: .JSONEncoding)
        
        return api.requestData(resource: resource)
    }
}
