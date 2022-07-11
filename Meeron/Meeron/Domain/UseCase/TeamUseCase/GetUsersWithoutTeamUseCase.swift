//
//  GetUsersWithoutTeamUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/07/11.
//

import Foundation
import RxSwift

class GetUsersWithoutTeamUseCase {
    let teamRepository = TeamRepository()
    func execute() -> Observable<[WorkspaceUser]?> {
        return teamRepository.getUsersWithoutTeam()
    }
}
