//
//  ErrorResponse.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/20.
//

import Foundation

struct ErrorResponse:Decodable {
    let status:Int
    let message:String
    let errors:[ErrorInfo]
}
struct ErrorInfo:Decodable {
    let field:String
    let value:String?
    let reason:String
}
