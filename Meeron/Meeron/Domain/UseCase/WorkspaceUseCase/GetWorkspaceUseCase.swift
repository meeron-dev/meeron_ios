//
//  GetWorkspaceUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/27.
//

import Foundation
import RxSwift

class GetWorkspaceUseCase {
    private let workspaceRepository = WorkspaceRepository()
    
    func execute() -> Observable<Workspace?> {
        return workspaceRepository.fetchWorkspaceInfo()
    }
}
