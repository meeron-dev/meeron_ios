//
//  WorkspaceUser.swift
//  Meeron
//
//  Created by 심주미 on 2022/07/11.
//

import Foundation

struct WorkspaceUser:Equatable {
    var workspaceUserId: Int
    var profileImageUrl: String?
    var nickname: String
    var position: String
    var email: String?
    var phone: String?
}
