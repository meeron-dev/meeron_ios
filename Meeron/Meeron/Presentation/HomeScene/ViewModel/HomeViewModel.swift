//
//  HomeViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/27.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    let goLoginViewSubject = PublishSubject<Bool>()
    
    let workspaceNameSubject = BehaviorSubject<String>(value: "워크스페이스")
    
    var todayMeetings:[TodayMeeting] = []
    let todayMeetingsSubject = BehaviorSubject<[TodayMeeting]>(value: [])
    
    let hasWorkspaceSubject = BehaviorSubject<Bool>(value: true)
    
    let todayMeetingCountSubject = BehaviorSubject<Int>(value: 0)
    
    
    let disposeBag = DisposeBag()
    
    let getUserUseCase = GetUserUseCase()
    let getUserWorkspaceUseCase = GetUserWorkspaceUseCase()
    let saveUserWorkspaceUseCase = SaveUserWorkspaceUseCase()
    let saveUserIdUseCase = SaveUserIdUseCase()
    
    let getWorkspaceUseCase = GetWorkspaceUseCase()
    let saveWorkspaceUseCase = SaveWorkspaceUseCase()
    
    let getTodayMeetingUseCase = GetTodayMeetingUseCase()
    
    func loadUser() {
        getUserUseCase
            .execute()
            .withUnretained(self)
            .subscribe(onNext: { owner, user in
                if let user = user {
                    owner.saveUserId(id: user.userId)
                    owner.loadUserWorkspace(id: user.userId)
                }else {
                    owner.goLoginViewSubject.onNext(true)
                }
            }).disposed(by: disposeBag)
        
    }
    
    func loadUserWorkspace(id:Int) {
        getUserWorkspaceUseCase
            .execute(id: id)
            .withUnretained(self)
            .subscribe(onNext: { owner, myWorkspaceUsers in
                if let myWorkspaceUsers = myWorkspaceUsers {
                    if myWorkspaceUsers.count > 0 {
                        owner.saveUserWorkspace(data: myWorkspaceUsers)
                        owner.loadWorkspaceInfo()
                    }else {
                        owner.hasWorkspaceSubject.onNext(false)
                    }
                }
                
            }).disposed(by: disposeBag)
    }
    
    func saveUserId(id:Int) {
        saveUserIdUseCase
            .execute(id: id)
    }
    
    func saveUserWorkspace(data:[MyWorkspaceUser]) {
        saveUserWorkspaceUseCase
            .execute(data: data)
        
    }
    
    func loadWorkspaceInfo()  {
        getWorkspaceUseCase
            .execute()
            .withUnretained(self)
            .subscribe(onNext: { owner, workspace in
                if let workspace = workspace {
                    owner.workspaceNameSubject.onNext(workspace.workspaceName)
                    owner.saveWorksapce(data: workspace)
                    owner.loadTodayMeeting()
                }
            }).disposed(by: disposeBag)
    }
    
    func saveWorksapce(data:Workspace) {
        saveWorkspaceUseCase
            .execute(data: data)
    }
    
    func loadTodayMeeting() {
        getTodayMeetingUseCase
            .execute()
            .withUnretained(self)
            .subscribe(onNext: { owner, meetings in
                if let meetings = meetings {
                    if meetings.count <= 10 {
                        owner.todayMeetings = meetings
                        owner.todayMeetingsSubject.onNext(meetings)
                        owner.todayMeetingCountSubject.onNext(meetings.count)
                    }else {
                        owner.todayMeetings = Array(meetings[..<11])
                        owner.todayMeetingsSubject.onNext(Array(meetings[..<11]))
                        owner.todayMeetingCountSubject.onNext(meetings.count)
                    }
                    
                }
            }).disposed(by: disposeBag)
    }
}
