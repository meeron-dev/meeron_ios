//
//  WorkspaceResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/27.
//

import Foundation


struct WorkspaceResponseDTO:Codable {
    var workspaceId:Int
    var workspaceName:String
    var workspaceLogoUrl:String?
}

extension WorkspaceResponseDTO {
    func toDomain() -> Workspace {
        return .init(workspaceId: workspaceId,
                     workspaceName: workspaceName,
                     workspaceLogoUrl: workspaceLogoUrl)
    }
}
