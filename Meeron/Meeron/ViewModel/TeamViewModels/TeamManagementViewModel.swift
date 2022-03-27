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
    var nowTeam:Team
    
    let participantsSubject = BehaviorSubject<[WorkspaceUser]>(value: [])
    let successTeamDeleteSubejct = PublishSubject<Bool>()
    
    
    init(participants:[WorkspaceUser], nowTeam:Team) {
        self.participants = participants
        self.nowTeam = nowTeam
        participantsSubject.onNext(participants)
    }
    
    func deleteProfile(data:WorkspaceUser) {
        if let index = participants.firstIndex(of: data) {
            participants.remove(at: index)
            participantsSubject.onNext(participants)
        }
    }
    
    func saveTeamName(teamName:String) {
        nowTeam.teamName = teamName
    }
    
    
    func deleteTeam(){
        successTeamDeleteSubejct.onNext(true)
    }
    
}
