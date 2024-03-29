//
//  TeamManagementViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/27.
//

import Foundation
import RxSwift

class TeamManagementViewModel {
    var participants:[WorkspaceUser] = []
    var nowTeam:Team?
    var newTeamName:String
    
    let participantsSubject = BehaviorSubject<[WorkspaceUser]>(value: [])
    let successTeamDeleteSubejct = PublishSubject<Bool>()
    
    let getUsersWithoutTeamUseCase = GetUsersWithoutTeamUseCase()
    let getUsersInWorkspaceTeamUseCase = GetUsersInWorkspaceTeamUseCase()
    let teamRepository = TeamRepository()
    let disposeBag = DisposeBag()
    
    init(participants:[WorkspaceUser], nowTeam:Team?) {
        self.participants = participants
        self.nowTeam = nowTeam
        self.newTeamName = nowTeam?.teamName ?? "NONE"
        participantsSubject.onNext(participants)
    }
    
    func loadParticipant() {
        if nowTeam == nil {
            getUsersWithoutTeamUseCase
                .execute()
                .withUnretained(self)
                .subscribe(onNext: { owner, users in
                    if let users = users {
                        owner.participantsSubject.onNext(users)
                        owner.participants = users
                    }
                }).disposed(by: disposeBag)
        }else {
            getUsersInWorkspaceTeamUseCase
                .execute(teamId: String(nowTeam!.teamId))
                .withUnretained(self)
                .subscribe(onNext: { owner, users in
                    if let users = users {
                        owner.participantsSubject.onNext(users)
                        owner.participants = users
                    }
                }).disposed(by: disposeBag)
        }
        
    }
    
    func deleteProfile(data:WorkspaceUser) {
        
        if let index = participants.firstIndex(of: data) {
            teamRepository.deleteParticipant(data: data)
                .withUnretained(self)
                .subscribe(onNext: { owner, success in
                    if success {
                        owner.participants.remove(at: index)
                        owner.participantsSubject.onNext(owner.participants)
                    }
                }).disposed(by: disposeBag)
            
        }
    }
    
    func saveTeamName(teamName:String) {
        newTeamName = teamName
    }
    
    
    func deleteTeam(){
        guard let nowTeam = nowTeam else {
            return
        }

        teamRepository.deleteTeam(teamId: nowTeam.teamId)
            .withUnretained(self)
            .subscribe(onNext: { owner, success in
                owner.successTeamDeleteSubejct.onNext(success)
            }).disposed(by: disposeBag)
        
    }
    
    func patchNewTeamName() {
        
        guard let nowTeam = nowTeam else {
            return
        }
        
        if newTeamName != nowTeam.teamName {
            teamRepository.patchNewTeamName(name: newTeamName, teamId: nowTeam.teamId)
        }
    }
    
}
