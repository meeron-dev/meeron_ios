//
//  WorkspaceCreation.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/21.
//

import Foundation

struct WorkspaceCreation {
    var workspaceName:String = ""
    var workspaceProfile = WorkspaceProfile()
    var teamName:String = ""
}

struct WorkspaceProfile {
    var image:Data?
    var nickname:String = ""
    var position:String = ""
    var email:String = ""
    var phoneNumber:String = ""
}

struct WorkspaceProfileCreation {
    var workspaceUserId : Int
    var nickname : String
    var position: String
    var profileImageUrl: String
    var email: String
    var phone : String
    var workspaceAdmin: Bool
}


struct WorkspaceCreationResponse: Codable {
    var workspaceId: Int
}

struct WorkspaceProfileNicknameCheckResponse: Codable {
    var duplicate: Bool
}
