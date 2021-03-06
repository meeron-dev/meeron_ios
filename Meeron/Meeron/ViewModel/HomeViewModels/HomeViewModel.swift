//
//  HomeViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/27.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    let failTokenSubject = PublishSubject<Bool>()
    
    let workspaceNameSubject = BehaviorSubject<String>(value: "워크스페이스")
    
    var todayMeetings:[TodayMeeting] = []
    let todayMeetingsSubject = BehaviorSubject<[TodayMeeting]>(value: [])
    
    let hasWorkspaceSubject = BehaviorSubject<Bool>(value: true)
    
    let todayMeetingCountSubject = BehaviorSubject<Int>(value: 0)
    
    let meetingRepository = MeetingRepository()
    let userRepository = UserRepository()
    
    let keychainManager = KeychainManager()
    let disposeBag = DisposeBag()
    
    func loadUser() {
        userRepository.loadUser()
            .withUnretained(self)
            .subscribe(onNext: { owner, user in
                if let user = user {
                    owner.saveUserId(id: user.userId)
                    owner.loadUserWorkspace(id: user.userId)
                    
                }else {
                    owner.reissueToken()
                }
            }).disposed(by: disposeBag)
        
    }
    func reissueToken() {
        userRepository.reissueToken()
            .withUnretained(self)
            .subscribe(onNext: { owner, token in
                if let token = token {
                    owner.saveToken(token: token)
                }else {
                    owner.failTokenSubject.onNext(true)
                }
            }).disposed(by: disposeBag)
    }
    
    func saveToken(token:Token) {
        if keychainManager.saveLoginToken(accessToken: token.accessToken, refreshToken: token.refreshToken) {
            loadUser()
        }
    }
    
    func loadUserWorkspace(id:Int) {
        
        userRepository.loadUserWorkspace(id: id)
            .withUnretained(self)
            .subscribe(onNext: { owner, userWorkspace in
                if let userWorkspace = userWorkspace {
                    print("🤓", userWorkspace)
                    if userWorkspace.myWorkspaceUsers.count > 0 {
                        owner.saveUserWorkspace(data: userWorkspace.myWorkspaceUsers)
                        owner.loadWorkspaceInfo()
                    }else {
                        owner.hasWorkspaceSubject.onNext(false)
                    }
                }
                
            }).disposed(by: disposeBag)
    }
    
    func saveUserId(id:Int) {
        userRepository.saveUserId(id: id)
    }
    
    func saveUserWorkspace(data:[MyWorkspaceUser]) {
        userRepository.saveUserWorkspace(data: data)
        
    }
    
    func loadWorkspaceInfo()  {
        userRepository.loadWorkspaceInfo()
            .withUnretained(self)
            .subscribe(onNext: { owner, workspace in
                if let workspace = workspace {
                    print("🟡", workspace)
                    owner.workspaceNameSubject.onNext(workspace.workspaceName)
                    owner.saveWorksapce(data: workspace)
                    owner.loadTodayMeeting()
                }
            }).disposed(by: disposeBag)
    }
    
    func saveWorksapce(data:Workspace) {
        userRepository.saveWorkspace(data: data)
    }
    
    func loadTodayMeeting() {
        meetingRepository.loadTodayMeeting()
            .withUnretained(self)
            .subscribe(onNext: { owner, meetings in
                if let meetings = meetings {
                    print(meetings)
                    if meetings.meetings.count <= 10 {
                        owner.todayMeetings = meetings.meetings
                        owner.todayMeetingsSubject.onNext(meetings.meetings)
                        owner.todayMeetingCountSubject.onNext(meetings.meetings.count)
                    }else {
                        owner.todayMeetings = Array(meetings.meetings[..<11])
                        owner.todayMeetingsSubject.onNext(Array(meetings.meetings[..<11]))
                        owner.todayMeetingCountSubject.onNext(meetings.meetings.count)
                    }
                    
                }
            }).disposed(by: disposeBag)
    }
}
