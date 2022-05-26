//
//  MyWorkspaceUserResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/26.
//

import Foundation

struct MyWorkspaceUserResponseDTO: Codable {
    var workspaceUserId: Int
    var workspaceId: Int
    var nickname: String?
    var profileImageUrl: String?
    var position: String?
    var email:String?
    var phone:String?
    var workspaceAdmin: Bool
}

extension MyWorkspaceUserResponseDTO {
    func toDomain() -> MyWorkspaceUser {
        return .init(workspaceUserId: workspaceUserId,
                     workspaceId: workspaceId,
                     nickname: nickname,
                     profileImageUrl: profileImageUrl,
                     position: position,
                     email: email,
                     phone: phone,
                     workspaceAdmin: workspaceAdmin)
    }
}
