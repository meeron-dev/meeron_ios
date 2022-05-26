//
//  SaveWorkspaceUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/27.
//

import Foundation

class SaveWorkspaceUseCase {
    private let workspaceRepository = WorkspaceRepository()
    
    func execute(data: Workspace) {
        workspaceRepository.saveWorkspace(data: data)
    }
}
