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
    
    let disposeBag = DisposeBag()
    
    func setManagers(datas:[WorkspaceUser]) {
        managers = datas
    }
    
    func getManagerNames(datas:[WorkspaceUser]) -> [String] {
        var managerNames:[String] = []
        _ = datas.map{ managerNames.append($0.nickname) }
        
        return managerNames
    }
    
    func setTeam(data:Team?) {
        team = data
    }
    
}
