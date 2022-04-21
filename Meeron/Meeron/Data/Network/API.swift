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
import Kingfisher
import UIKit
import AWSS3

//import Amplify

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
        print(resource)
        
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
                    print("✅",response.debugDescription)
                    return Observable.just(true)
                default:
                    print("📍",response.debugDescription)
                    return Observable.just(false)
                }
        }
    }
    
    
    
    func upload(resource: Resource<Bool>, data:Data?, fileName:String?, mimeType:String?) -> Observable<Bool> {
        print(resource)
        return Observable.create({ observable in
            AF.upload(multipartFormData: { multipartFormData in
                
                for (key, value) in resource.parameter {
                    multipartFormData.append(Data((value as! String).utf8), withName: key, mimeType: "application/json")
                }
                
                if let data = data, let fileName = fileName, let mimeType = mimeType {
                    
                    multipartFormData.append(data, withName: "files", fileName: fileName, mimeType: mimeType)
                }
                
            
            }, to: resource.url, usingThreshold: UInt64.init(), method: resource.method, headers: ["Content-Type": "multipart/form", "Authorization": "Bearer " + KeychainManager().read(service: "Meeron", account: "accessToken")!])
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
    
    func downloadFile(url:String, fileName:String) {
        let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
        getPreSignedURLRequest.bucket = "meeron-bucket"
        getPreSignedURLRequest.key = "files/"+(url.split(separator: "/").map{String($0)}.last ?? "")
        getPreSignedURLRequest.httpMethod = .GET
        getPreSignedURLRequest.expires = Date(timeIntervalSinceNow: 3600)  // Change the value of the expires time interval as required
        AWSS3PreSignedURLBuilder.default().getPreSignedURL(getPreSignedURLRequest).continueWith { (task:AWSTask<NSURL>) -> Any? in
            if let error = task.error as NSError? {
                print("Error: \(error)")
                return nil
            }
            if let presignedURL = task.result?.absoluteURL {
                
                self.download(url: presignedURL, fileName: fileName)
            }
            return nil
        }
        
    }
    
    
    func download(url:URL, fileName:String) {
        let fileManager = FileManager.default
                // 앱 경로
        let appURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                // 파일이름 url 의 맨 뒤 컴포넌트로 지정 (50MB.zip)
        //let fileName : String = URL(string: url)!.lastPathComponent
                // 파일 경로 생성
        let fileURL = appURL.appendingPathComponent(fileName)
                // 파일 경로 지정 및 다운로드 옵션 설정 ( 이전 파일 삭제 , 디렉토리 생성 )
        let destination: DownloadRequest.Destination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        
        AF.download(url, headers: ["Content-Type":"application/octet-stream"], to: destination)
            .downloadProgress { progress in
                print(progress.fractionCompleted,"✔️")
            }.response {response in
                if response.error != nil {
                    print("파일다운로드 실패")
                }else{
                    print("파일다운로드 완료")
                }
            }
    }
    
    func getImageResource(url:String, completion: @escaping (ImageResource?)->()) {
        let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
        getPreSignedURLRequest.bucket = "meeron-bucket"
        getPreSignedURLRequest.key = "files/"+(url.split(separator: "/").map{String($0)}.last ?? "")
        getPreSignedURLRequest.httpMethod = .GET
        getPreSignedURLRequest.expires = Date(timeIntervalSinceNow: 3600)  // Change the value of the expires time interval as required
        AWSS3PreSignedURLBuilder.default().getPreSignedURL(getPreSignedURLRequest).continueWith { (task:AWSTask<NSURL>) -> Any? in
            if let error = task.error as NSError? {
                print("Error: \(error)")
                return nil
            }
            if let presignedURL = task.result {
                
                DispatchQueue.main.async {
                    let resource = ImageResource(downloadURL: URL(string: presignedURL.absoluteString!)!, cacheKey: "files/"+(url.split(separator: "/").map{String($0)}.last ?? ""))
                    completion(resource)
                }
            }
            return nil
        }
        completion(nil)
    }
    
    
}
