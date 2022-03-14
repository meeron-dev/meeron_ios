//
//  MeetingTeamSelectViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/08.
//

import Foundation
import RxSwift

class MeetingTeamSelectViewModel {
    
    var teams:[Team] = []
    var teamsSubject = PublishSubject<[Team]>()
    var selectedTeam:Team?
    var selectedTeamSubject = BehaviorSubject<Team?>(value: nil)
    
    let teamRepository = TeamRepository()
    
    let disposeBag = DisposeBag()
    
    init() {
        selectedTeamSubject.subscribe(onNext: { [weak self] selectedTeam in
            self?.selectedTeam = selectedTeam
        }).disposed(by: disposeBag)
    }
    
    
    func loadTeamInWorkspace() {
        teamRepository.loadTeamInWorkspace()
            .withUnretained(self)
            .subscribe(onNext: { owner, teams in
                if let teams = teams {
                    owner.teams = teams.teams
                    owner.teamsSubject.onNext(teams.teams)
                }
            }).disposed(by: disposeBag)
    }
}
