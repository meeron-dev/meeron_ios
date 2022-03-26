//
//  Networking.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/19.
//

import Foundation
import RxAlamofire
import RxSwift
import Alamofire
import UIKit

enum EncodingType {
    case JSONEncoding
    case URLEncoding
}

struct Resource<T:Codable> {
    let url:String
    let parameter:[String:Any]
    let headers:HTTPHeaders
    let method:HTTPMethod
    let encodingType:EncodingType
    var encoding:ParameterEncoding {
        if encodingType == .JSONEncoding {
            return JSONEncoding.default
        }else {
            return URLEncoding.default
        }
    }
}



struct API {
    
    func requestData<T:Codable>(resource:Resource<T>) -> Observable<T?> {
        return RxAlamofire.requestData(resource.method, resource.url, parameters: resource.parameter, encoding: resource.encoding, headers: resource.headers)
            .flatMap({ (response, data) -> Observable<T?> in
                print("✅", response)
                switch response.statusCode {
                case 200...299 :
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    return Observable.just(decodedData)
                default:
                    print("📍",response.debugDescription)
                    return Observable.just(nil)
                }
            })
    }
    
    func requestResponse(resource:Resource<Bool>) -> Observable<Bool> {
        return RxAlamofire.requestResponse(resource.method, resource.url, parameters: resource.parameter, encoding: resource.encoding, headers: resource.headers)
            .flatMap { response -> Observable<Bool> in
                switch response.statusCode{
                case 200...299:
                    return Observable.just(true)
                default:
                    print("📍",response.debugDescription)
                    return Observable.just(false)
                }
        }
    }
    
    func upload(resource: Resource<Bool>, data:Data?) -> Observable<Bool> {
        print(resource)
        return Observable.create({ observable in
            AF.upload(multipartFormData: { multipartFormData in
                
                for (key, value) in resource.parameter {
                    multipartFormData.append(Data((value as! String).utf8), withName: key, mimeType: "application/json")
                }
                
                if let data = data {
                    multipartFormData.append(data, withName: "files", fileName: ".png", mimeType: "mine/png")
                }
                
            
            }, to: resource.url, usingThreshold: UInt64.init(), method: .post, headers: ["Content-Type": "multipart/form", "Authorization": "Bearer " + KeychainManager().read(service: "Meeron", account: "accessToken")!])
                .response { response in
                    print("✔️",response.debugDescription)
                    guard let statusCode = response.response?.statusCode else {
                        return observable.onNext(false)
                    }
                    
                    switch statusCode {
                    case 200...299:
                        return observable.onNext(true)
                    default:
                        return observable.onNext(false)
                    }
                    
                }
            
            return Disposables.create()
        })
    }
}
