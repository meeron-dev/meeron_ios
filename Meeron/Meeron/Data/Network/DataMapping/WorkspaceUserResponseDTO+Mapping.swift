//
//  WorkspaceUserResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/07/11.
//

import Foundation

struct WorkspaceUserResponseDTO: Codable {
    var workspaceUserId: Int
    var profileImageUrl: String?
    var nickname: String
    var position: String
    var email: String?
    var phone: String?
}

extension WorkspaceUserResponseDTO {
    func toDomain() -> WorkspaceUser {
        return .init(workspaceUserId: workspaceUserId,
                     profileImageUrl: profileImageUrl,
                     nickname: nickname,
                     position: position,
                     email: email,
                     phone: phone)
    }
}
