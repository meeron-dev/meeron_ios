//
//  User.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/26.
//

import Foundation

//import RealmSwift
/*
class UserInfo: Object{
    @objc dynamic var userId: Int = 0
    let userWorkspaces:List<UserWorkspaceInfo> = List<UserWorkspaceInfo>()
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
    convenience init(userId:Int) {
        self.init()
        self.userId = userId
    }
}

class UserWorkspaceInfo: Object {
    @objc dynamic var workspaceId:Int = 0
    @objc dynamic var workspaceUserId:Int = 0
    
    let ofUserInfo = LinkingObjects(fromType:UserInfo.self, property:"userWorkspaces" )
    
    convenience init(workspaceId:Int, workspaceUserId:Int) {
        self.init()
        self.workspaceId = workspaceId
        self.workspaceUserId = workspaceUserId
    }
}
*/
struct User:Codable {
    var userId: Int
    var loginEmail: String
    var contactEmail: String?
    var name: String?
    var profileImageUrl: String?
    var phone:String?
}

struct UserWorkspace:Codable {
    var myWorkspaceUsers:[MyWorkspaceUser]
}

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
