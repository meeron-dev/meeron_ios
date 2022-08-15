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
    
    //let teamRepository = TeamRepository()
    let getTeamsInWorkspaceUseCase = GetTeamsInWorkspaceUseCase()
    let getUsersWithoutTeamUseCase = GetUsersWithoutTeamUseCase()
    let getUsersInWorkspaceTeamUseCase = GetUsersInWorkspaceTeamUseCase()
    
    let disposeBag = DisposeBag()
    
    //let isAdmin = UserDefaults.standard.bool(forKey: "workspaceAdmin")
    
    init() {
        //print("관리자",isAdmin,"✔️")
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
        getTeamsInWorkspaceUseCase
            .execute()
            .withUnretained(self)
            .subscribe(onNext: { owner, teams in
                if var teams = teams {
                    for i in 0..<teams.count {
                        teams[i].teamOrder = i+1
                    }
                    
                    if UserDefaults.standard.bool(forKey: "workspaceAdmin") {
                        if teams.count >= 5 {
                            owner.teams = teams
                        }else {
                            owner.teams = [nil]+teams
                        }
                        print(owner.teams,"📍")
                    }else {
                        owner.teams = teams
                    }
                    print("📍",owner.teams)
                    owner.loadNoneTeam()
                }
            }).disposed(by: disposeBag)
    }
    
    func loadNoneTeam() {
        
        getUsersWithoutTeamUseCase
            .execute()
            .withUnretained(self)
            .subscribe(onNext: { owner, users in
                if let users = users {
                    if users.count > 0 {
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
        if UserDefaults.standard.bool(forKey: "workspaceAdmin") {
            if teams.count > 1 {    //+제외
                if teams[0] != nil {
                    nowTeamSubject.onNext(teams[0]) //  팀이 5개여서 +가 없을 때
                }else {
                    nowTeamSubject.onNext(teams[1])
                }
                loadParticipant()
                print(teams)
            }else {
                nowTeamSubject.onNext(nil)
            }
        }else {
            if teams.count > 0 {
                nowTeamSubject.onNext(teams[0])
                loadParticipant()
            }else {
                nowTeamSubject.onNext(nil)
            }
        }
        
    }
    
    func loadParticipantInNoneTeam() {
        getUsersWithoutTeamUseCase
            .execute()
            .withUnretained(self)
            .subscribe(onNext: { owner, users in
                if let users = users {
                    owner.saveParticipant(users: users)
                }
            }).disposed(by: disposeBag)
        
    }
    
    func loadParticipant() {
        guard let nowTeam = nowTeam else {
            return
        }

        getUsersInWorkspaceTeamUseCase
            .execute(teamId: String(nowTeam.teamId))
            .withUnretained(self)
            .subscribe(onNext: { owner, users in
                if let users = users {
                    owner.saveParticipant(users: users)
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
