//
//  User.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/26.
//

import Foundation

struct User:Codable {
    var userId: Int
    var loginEmail: String
    var contactEmail: String?
    var name: String?
    var profileImageUrl: String?
    var phone:String?
}
