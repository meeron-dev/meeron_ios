//
//  User.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/26.
//

import Foundation

/*struct UserWorkspace:Codable {
    var myWorkspaceUsers:[MyWorkspaceUser]
}*/


struct WorkspaceUserProfiles:Codable {
    var workspaceUsers:[WorkspaceUser]
}

struct WorkspaceUser:Codable, Equatable {
    var workspaceUserId: Int
    var profileImageUrl: String?
    var nickname: String
    var position: String
    var email: String?
    var phone: String?
}
