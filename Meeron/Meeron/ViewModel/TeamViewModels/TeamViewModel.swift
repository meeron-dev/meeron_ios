//
//  TeamViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/26.
//

import Foundation
import RxSwift
import Alamofire

class TeamViewModel {
    
    var nowTeam:Team?
    let nowTeamSubject = BehaviorSubject<Team>(value:Team(teamId: -1, teamName: "팀 이름"))
    
    var teams: [Team] = []
    var particiapnt:[WorkspaceUser] = []
    let teamsSubject = BehaviorSubject<[Team]>(value: [])
    let teamParticipantSubject = BehaviorSubject<[WorkspaceUser]>(value: [])
    
    let participantCountLabelHeightSubject = BehaviorSubject<CGFloat>(value: 20)
    
    let teamRepository = TeamRepository()
    
    let disposeBag = DisposeBag()
    
    let isAdmin = true //UserDefaults.standard.bool(forKey: "workspaceAdmin")
    
    init() {
        loadTeam()
        nowTeamSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, nowTeam in
                owner.nowTeam = nowTeam
                owner.loadParticipant()
            }).disposed(by: disposeBag)
    }
    
    func loadTeam() {
        teamRepository.loadTeamInWorkspace()
            .withUnretained(self)
            .subscribe(onNext: { owner, teams in
                if let teams = teams {
                    owner.teams = teams.teams
                    owner.teamsSubject.onNext(teams.teams)
                    owner.setNowTeam()
                }
            }).disposed(by: disposeBag)
    }
    
    func setNowTeam() {
        if teams.count > 0 {
            loadParticipant()
            nowTeamSubject.onNext(teams[0])
        }
    }
    
    func loadParticipant() {
        guard let nowTeam = nowTeam else {
            return
        }

        
        teamRepository.loadUsersInWorkspaceTeam(teamId: String(nowTeam.teamId))
            .withUnretained(self)
            .subscribe(onNext: { owner, users in
                if let users = users {
                    owner.particiapnt = users.workspaceUsers
                    owner.teamParticipantSubject.onNext(users.workspaceUsers)
                    if users.workspaceUsers.count > 0 {
                        owner.participantCountLabelHeightSubject.onNext(0)
                    }else {
                        owner.participantCountLabelHeightSubject.onNext(20)
                    }
                }
                
            }).disposed(by: disposeBag)
    }
}
