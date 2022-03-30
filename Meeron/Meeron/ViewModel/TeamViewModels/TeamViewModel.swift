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
    let nowTeamSubject = BehaviorSubject<Team?>(value:nil)
    
    var teams: [Team?] = []
    var particiapnt:[WorkspaceUser] = []
    let teamsSubject = BehaviorSubject<[Team?]>(value: [])
    let teamParticipantSubject = BehaviorSubject<[WorkspaceUser]>(value: [])
    
    var hasNoneTeam = false
    
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
                if nowTeam == nil {
                    owner.loadParticipantInNoneTeam()
                }else {
                    owner.loadParticipant()
                }
                
            }).disposed(by: disposeBag)
    }
    
    func loadTeam() {
        teamRepository.loadTeamInWorkspace()
            .withUnretained(self)
            .subscribe(onNext: { owner, teams in
                if let teams = teams {
                    if owner.isAdmin {
                        owner.teams = [nil]+teams.teams
                    }else {
                        owner.teams = teams.teams
                    }
                    
                    owner.loadNoneTeam()
                }
            }).disposed(by: disposeBag)
    }
    
    func loadNoneTeam() {
        teamRepository.loadUsersWithoutTeam()
            .withUnretained(self)
            .subscribe(onNext: { owner, users in
                if let users = users {
                    if users.workspaceUsers.count > 0 {
                        owner.hasNoneTeam = true
                        owner.teams.append(nil)
                        
                    }else {
                        owner.hasNoneTeam = false
                    }
                    owner.teamsSubject.onNext(owner.teams)
                    owner.setNowTeam()
                }
            }).disposed(by: disposeBag)
    }
    
    func setNowTeam() {
        if isAdmin {
            if teams.count > 1 {    //+제외
                loadParticipant()
                nowTeamSubject.onNext(teams[1])
            }
        }else {
            if teams.count > 0 {
                loadParticipant()
                nowTeamSubject.onNext(teams[0])
            }
        }
        
    }
    
    func loadParticipantInNoneTeam() {
            teamRepository.loadUsersWithoutTeam()
                .withUnretained(self)
                .subscribe(onNext: { owner, users in
                    if let users = users {
                        owner.saveParticipant(users: users.workspaceUsers)
                    }
                }).disposed(by: disposeBag)
        
    }
    
    func loadParticipant() {
        guard let nowTeam = nowTeam else {
            return
        }

        
        teamRepository.loadUsersInWorkspaceTeam(teamId: String(nowTeam.teamId))
            .withUnretained(self)
            .subscribe(onNext: { owner, users in
                if let users = users {
                    owner.saveParticipant(users: users.workspaceUsers)
                }
                
            }).disposed(by: disposeBag)
    }
    
    func saveParticipant(users:[WorkspaceUser]) {
        particiapnt = users
        teamParticipantSubject.onNext(users)
        if users.count > 0 {
            participantCountLabelHeightSubject.onNext(0)
        }else {
            participantCountLabelHeightSubject.onNext(20)
        }
    
    }
}
