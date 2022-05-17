//
//  SignUpRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/19.
//

import Foundation
import Alamofire
import RxSwift

class DefaultSignUpRepository: SignUpRepository {
    
    func saveUserName(name:String) -> Observable<Bool>{
        let headers:HTTPHeaders = [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)]
        
        let resource = Resource<Bool>(url: URLConstant.userName, parameter: ["name":name], headers: headers, method: .patch, encodingType: .JSONEncoding)
        
        return API.requestResponse(resource: resource)
    }
    
    
}
