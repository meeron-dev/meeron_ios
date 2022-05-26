//
//  UserWorkspaceResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/27.
//

import Foundation

struct UserWorkspaceResponseDTO:Codable {
    var myWorkspaceUsers:[MyWorkspaceUserResponseDTO]
}

extension UserWorkspaceResponseDTO {
    func toDomain() -> [MyWorkspaceUser] {
        return myWorkspaceUsers.map{$0.toDomain()}
    }
}
