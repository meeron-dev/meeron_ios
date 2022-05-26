//
//  MyWorkspaceUser.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/27.
//

import Foundation

struct MyWorkspaceUser:Codable {
    var workspaceUserId: Int
    var workspaceId: Int
    var nickname: String?
    var profileImageUrl: String?
    var position: String?
    var email:String?
    var phone:String?
    var workspaceAdmin: Bool
}
