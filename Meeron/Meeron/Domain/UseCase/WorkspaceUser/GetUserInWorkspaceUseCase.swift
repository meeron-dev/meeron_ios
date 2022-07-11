//
//  GetUserInWorkspaceUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/07/11.
//

import Foundation
import RxSwift

class GetUserInWorkspaceUseCase {
    let workspaceUserRepository = WorkspaceUserRepository()
    
    func execute(nickname: String) -> Observable<[WorkspaceUser]?> {
        return workspaceUserRepository.getUserInWorkspace(nickname: nickname)
    }
}
