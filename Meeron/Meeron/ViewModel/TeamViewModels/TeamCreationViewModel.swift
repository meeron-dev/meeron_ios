//
//  TeamCreationViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/30.
//

import Foundation
import RxSwift

class TeamCreationViewModel {
    let teamRepository = TeamRepository()
    var participants:[WorkspaceUser] = []
    
    var selectedParticipants:[WorkspaceUser] = []
    
    var successTeamCreation = BehaviorSubject<Bool>(value: false)
    
    let participantsSubject = BehaviorSubject<[WorkspaceUser]>(value: [])
    let selectedParticipantsCountSubject = BehaviorSubject<Int>(value: 0)
    let noParticipantLabelWidthSubejct = BehaviorSubject<CGFloat>(value: 0)
    
    let disposeBag = DisposeBag()
    
    var teamName:String
    
    init(teamName:String) {
        self.teamName = teamName
        participantsSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, users in
                owner.participants = users
                if users.count == 0 {
                    owner.noParticipantLabelWidthSubejct.onNext(205)
                }else {
                    owner.noParticipantLabelWidthSubejct.onNext(0)
                }
                
            }).disposed(by: disposeBag)
        loadUsersWithoutTeam()
    }
    
    
    func selectProfile(data:WorkspaceUser) {
        if let index = selectedParticipants.firstIndex(of: data) {
            selectedParticipants.remove(at: index)
        }else {
            selectedParticipants.append(data)
        }
        selectedParticipantsCountSubject.onNext(selectedParticipants.count)
        participantsSubject.onNext(participants)
    }
    
    func isSelectedProfile(data:WorkspaceUser) -> Bool {
        if selectedParticipants.contains(data) {
            return true
        }else {
            return false
        }
    }
    
    
    func loadUsersWithoutTeam() {
        teamRepository.loadUsersWithoutTeam()
            .withUnretained(self)
            .subscribe(onNext: { owner, users in
                if let users = users {
                    owner.participantsSubject.onNext(users.workspaceUsers)
                }
            }).disposed(by: disposeBag)
    }
    
    func createTeam() {
        teamRepository.createTeam(name: teamName)
            .withUnretained(self)
            .subscribe(onNext: { owner, team in
                if let team = team {
                    owner.createParticipant(teamId: team.createdTeamId)
                }
            }).disposed(by: disposeBag)
    }
    
    func createParticipant(teamId:Int) {
        if selectedParticipants.count == 0 {
            successTeamCreation.onNext(true)
        }else {
            teamRepository.createParticipant(teamId: teamId, datas: selectedParticipants)
                .withUnretained(self)
                .subscribe(onNext: { owner, result in
                    owner.successTeamCreation.onNext(result)
                    
                }).disposed(by: disposeBag)
        }
        
    }
}
