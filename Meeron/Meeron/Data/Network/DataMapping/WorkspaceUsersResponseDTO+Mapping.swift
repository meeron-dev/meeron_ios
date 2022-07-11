//
//  WorkspaceUsersResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/07/11.
//

import Foundation

struct WorkspaceUsersResponseDTO: Codable {
    var workspaceUsers:[WorkspaceUserResponseDTO]
}

extension WorkspaceUsersResponseDTO {
    func toDomain() -> [WorkspaceUser] {
        return workspaceUsers.map{$0.toDomain()}
    }
}
