//
//  GetTeamInWorkspaceUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/07/11.
//

import Foundation
import RxSwift

class GetTeamsInWorkspaceUseCase {
    let teamRepository = TeamRepository()
    
    func execute() -> Observable<[Team]?> {
        return teamRepository.getTeamsInWorkspace()
    }
}
