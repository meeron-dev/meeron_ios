//
//  GetUsersInWorkspaceTeamUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/07/11.
//

import Foundation
import RxSwift

class GetUsersInWorkspaceTeamUseCase {
    let teamRepository = TeamRepository()
    func execute(teamId: String) -> Observable<[WorkspaceUser]?> {
        return teamRepository.getUsersInWorkspaceTeam(teamId: teamId)
    }
}
