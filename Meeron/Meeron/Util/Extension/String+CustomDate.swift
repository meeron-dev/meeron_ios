//
//  String+CustomDate.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/24.
//

import Foundation

extension String {
    func getDay() -> String{
        return String(Int(String(self.split(separator: "-")[2]))!)
    }
    func toKoreanDateString() -> String {
        let dateString = self.split(separator: "/").map{String($0)}
        return dateString[0] + "년 " + String(Int(dateString[1])!) + "월 " + String(Int(dateString[2])!)+"일"
    }
}
