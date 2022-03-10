//
//  MeetingParticipantCreationViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/06.
//

import Foundation
import RxSwift

class MeetingParticipantCreationViewModel {
    var teams:[Team] = []
    let teamsSubject = BehaviorSubject<[Team]>(value: [])
    
    var nowTeam:Team?
    let nowTeamSubject = BehaviorSubject<Team?>(value: nil)
    
    var userProfiles:[WorkspaceUser] = []
    let userProfilesSubejct = PublishSubject<[WorkspaceUser]>()
    
    var selectedUserProfiles:[WorkspaceUser] = []
    var selectedUserProfilesCountSubject = BehaviorSubject<Int>(value: 0)
    
    let teamRepository = TeamRepository()
    
    let disposeBag = DisposeBag()
    
    init(){
        loadTeamInWorkspace()
        nowTeamSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, team in
                owner.chageNowTeam(team: team)
            }).disposed(by: disposeBag)
    }
    
    func chageNowTeam(team:Team?) {
        if let nowTeam = nowTeam {
            teams.append(nowTeam)
        }
        if let team = team {
            if let index = teams.firstIndex(of:team) {
                teams.remove(at: index)
            }
        }
        teamsSubject.onNext(teams)
        nowTeam = team
        loadUsersInWorkspaceTeam()
    }
    
    func isSelectedUserProfile(data:WorkspaceUser) -> Bool {
        if selectedUserProfiles.contains(data) {
            return true
        }
        return false
    }
    
    func addSelectedUserProfile(data:WorkspaceUser) {
        selectedUserProfiles.append(data)
        selectedUserProfilesCountSubject.onNext(selectedUserProfiles.count)
    }
    
    func addSelectedUserProfiles(data:[WorkspaceUser]) {
        selectedUserProfiles += data
        selectedUserProfilesCountSubject.onNext(selectedUserProfiles.count)
    }
    
    func deleteSelectedUserProfile(data:WorkspaceUser) {
        if let index = selectedUserProfiles.firstIndex(of: data) {
            selectedUserProfiles.remove(at: index)
            selectedUserProfilesCountSubject.onNext(selectedUserProfiles.count)
        }
    }
    
    func selectUserProfile(data:WorkspaceUser) {
        if isSelectedUserProfile(data: data) {
            deleteSelectedUserProfile(data: data)
        }else {
            addSelectedUserProfile(data: data)
        }
        userProfilesSubejct.onNext(userProfiles)
    }
    
    func loadTeamInWorkspace() {
        teamRepository.loadTeamInWorkspace()
            .withUnretained(self)
            .subscribe(onNext: { owner, teams in
                if let teams = teams {
                    if teams.teams.count > 0 {
                        owner.nowTeamSubject.onNext(teams.teams[0])
                    }
                    if teams.teams.count > 1 {
                        owner.teams = Array(teams.teams[1...])
                        owner.teamsSubject.onNext(Array(teams.teams[1...]))
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func loadUsersInWorkspaceTeam() {
        guard let nowTeam = nowTeam else {
            return
        }
        
        teamRepository.loadUsersInWorkspaceTeam(teamId: String(nowTeam.teamId))
            .withUnretained(self)
            .subscribe(onNext: { owner, users in
                if let users = users {
                    owner.userProfiles = users.workspaceUsers
                    owner.userProfilesSubejct.onNext(users.workspaceUsers)
                    print(users)
                }
                
            }).disposed(by: disposeBag)
    }
}
