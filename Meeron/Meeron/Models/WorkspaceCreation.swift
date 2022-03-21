//
//  WorkspaceCreation.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/21.
//

import Foundation

struct WorkspaceCreation {
    var workspaceName:String = ""
    /*
     var workspaceUserName:String
     var position:String
     var email:String
     var phoneNumber:String
     */
    var teamName:String = ""
}


struct WorkspaceCreationResponse: Codable {
    var workspaceId: Int
}
