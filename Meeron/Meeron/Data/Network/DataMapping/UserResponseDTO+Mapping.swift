//
//  UserResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/26.
//

import Foundation

struct UserResponseDTO:Codable {
    var userId: Int
    var loginEmail: String
    var contactEmail: String?
    var name: String?
    var profileImageUrl: String?
    var phone:String?
}

extension UserResponseDTO {
    func toDomain() -> User {
        return .init(userId: userId,
                     loginEmail: loginEmail,
                     contactEmail: contactEmail,
                     name: name,
                     profileImageUrl: profileImageUrl,
                     phone: phone)
    }
}
