//
//  MeetingTeamSelectViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/08.
//

import Foundation
import RxSwift

class MeetingTeamSelectViewModel {
    
    var teams:[Team] = []
    var teamsSubject = PublishSubject<[Team]>()
    var selectedTeam:Team?
    var selectedTeamSubject = PublishSubject<Team?>()
    let disposeBag = DisposeBag()
    
    init() {
        selectedTeamSubject.subscribe(onNext: { [weak self] selectedTeam in
            self?.selectedTeam = selectedTeam
        }).disposed(by: disposeBag)
    }
    
    
    func loadTeamInWorkspace() {
        guard let workspaceId = UserDefaults.standard.string(forKey: "workspaceId") else {return}
        
        let urlString = URLConstant.teamInWorkspace+"?workspaceId="+workspaceId

        let resource = Resource<Teams>(url:urlString, parameter: [:], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
        
        API().load(resource: resource)
            .subscribe(onNext: { [weak self] teams in
                if let teams = teams {
                    self?.teams = teams.teams
                    self?.teamsSubject.onNext(teams.teams)
                }
            }).disposed(by: disposeBag)
    }
}
