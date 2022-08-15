//
//  TeamParticipantAdditionalViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/28.
//

import Foundation
import RxSwift

class TeamParticipantAdditionalViewModel {
    let teamRepository = TeamRepository()
    var participants:[WorkspaceUser] = []
    
    var selectedParticipants:[WorkspaceUser] = []
    
    var successParticipantAddtitionalSubject = BehaviorSubject<Bool>(value: false)
    
    let participantsSubject = BehaviorSubject<[WorkspaceUser]>(value: [])
    let selectedParticipantsCountSubject = BehaviorSubject<Int>(value: 0)
    let noParticipantLabelWidthSubejct = BehaviorSubject<CGFloat>(value: 0)
    
    let getUsersWithoutTeamUseCase = GetUsersWithoutTeamUseCase()
    
    let disposeBag = DisposeBag()
    
    let teamId:Int
    init(teamId:Int) {
        self.teamId = teamId
        
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
        getUsersWithoutTeamUseCase
            .execute()
            .withUnretained(self)
            .subscribe(onNext: { owner, users in
                if let users = users {
                    owner.participantsSubject.onNext(users)
                }
            }).disposed(by: disposeBag)
    }
    
    
    func addParticipant() {
        teamRepository.createParticipant(teamId: teamId, datas: selectedParticipants)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                owner.successParticipantAddtitionalSubject.onNext(result)
                
            }).disposed(by: disposeBag)
    }
}
