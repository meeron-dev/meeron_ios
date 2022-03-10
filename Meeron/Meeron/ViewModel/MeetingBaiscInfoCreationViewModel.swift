//
//  MeetingBaiscInfoCreationViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/07.
//

import Foundation
import RxSwift

class MeetingBaiscInfoCreationViewModel {
    
    var managers:[WorkspaceUser] = []
    var team:Team?
    var title:String = ""
    var purpose:String = ""
    
    let validTitleSubject = BehaviorSubject<Bool>(value: false)
    let validPurposeSubject = BehaviorSubject<Bool>(value: false)
    let validTeamSubject = BehaviorSubject<Bool>(value: false)
    
    let disposeBag = DisposeBag()
   
    func setTitle(title:String) {
        self.title = title
        if title != "" {
            validTitleSubject.onNext(true)
        }else {
            validTitleSubject.onNext(false)
        }
    }
    
    func setPurpose(purpose:String) {
        self.purpose = purpose
        if purpose != "" {
            validPurposeSubject.onNext(true)
        }else {
            validPurposeSubject.onNext(false)
        }
    }
    
    func setTeam(team:Team?) {
        self.team = team
        if team != nil {
            validTeamSubject.onNext(true)
        }else{
            validTeamSubject.onNext(false)
        }
    }
    
    func setManagers(managers:[WorkspaceUser]) {
        self.managers = managers
    }
    
    func getManagerNames(datas:[WorkspaceUser]) -> [String] {
        var managerNames:[String] = []
        _ = datas.map{ managerNames.append($0.nickname) }
        
        return managerNames
    }
    
    
}
