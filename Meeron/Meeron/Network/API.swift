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

enum EncodingType {
    case JSONEncoding
    case URLEncoding
}

struct Resource<T:Codable> {
    let url:String
    let parameter:[String:String]
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
    
    let disposeBag = DisposeBag()
    
    let protocolHost = "https://dev.meeron.net"
    
    func load<T:Codable>(resource:Resource<T>) -> Observable<T?> {
        
        return RxAlamofire.requestData(resource.method, resource.url, parameters: resource.parameter, encoding: resource.encoding, headers: resource.headers)
            .flatMap({ (response, data) -> Observable<T?> in
                switch response.statusCode {
                case 200...299 :
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    return Observable.just(decodedData)
                default:
                    return Observable.just(nil)
                }
            })
    }
    
    func login(email:String, nickname:String, profileImageUrl:String, provider:String) {
        let url = protocolHost + "/api/login"
        let parameters = ["email":email, "nickname":nickname,"profileImageUrl":profileImageUrl,"provider":provider]
        RxAlamofire.requestJSON(.post, url, parameters: parameters, encoding: JSONEncoding.default,headers: ["Content-Type": "application/json"])
            .subscribe(onNext: { response, json in
                print("Login network:", response, json)
            }, onError: { error in
                print("login network error:",error)
            }).disposed(by: disposeBag)
    }
}
