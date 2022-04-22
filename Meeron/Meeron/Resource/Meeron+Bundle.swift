//
//  Meeron+Bundle.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/21.
//

import Foundation

extension Bundle {
    var kakaoAppKey: String {
        guard let file = self.path(forResource: "Keys", ofType: "plist") else {return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else {return ""}
        guard let key = resource["Kakao App Key"] as? String else {fatalError("Keys.plist에 Kakao App Key 설정을 해주세요.")}
        return key
    }
    
    var s3PoolId: String {
        guard let file = self.path(forResource: "Keys", ofType: "plist") else {return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else {return ""}
        guard let key = resource["S3 Pool Id"] as? String else {fatalError("Keys.plist에 S3 Pool Id 설정을 해주세요.")}
        return key
    }
}
