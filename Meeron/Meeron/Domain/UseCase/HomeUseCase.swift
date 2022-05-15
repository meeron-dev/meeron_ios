//
//  HomeUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/12.
//

import Foundation
import RxSwift

protocol HomeUseCase {
    func fetchUser() -> Observable<User?>
    func fetchUserWorkspace(id:Int) -> Observable<UserWorkspace?>
    func saveUserId(id:Int)
    func saveUserWorkspace(data:[MyWorkspaceUser])
    func fetchWorkspaceInfo() -> Observable<Workspace?>
    func saveWorksapce(data:Workspace)
    func loadTodayMeeting() -> Observable<TodayMeetings?>
}


class DefaultHomeUseCase:HomeUseCase {
    private let meetingRepository = MeetingRepository()
    private let userRepository = DefaultUserRepository()
    
    
    func fetchUser() -> Observable<User?> {
        return userRepository.fetchUser()
        
    }
    
    func fetchUserWorkspace(id:Int) -> Observable<UserWorkspace?> {
        return userRepository.fetchUserWorkspace(id: id)
    }
    
    func saveUserId(id:Int) {
        userRepository.saveUserId(id: id)
    }
    
    func saveUserWorkspace(data:[MyWorkspaceUser]) {
        userRepository.saveUserWorkspace(data: data)
        
    }
    
    func fetchWorkspaceInfo() -> Observable<Workspace?> {
        return userRepository.fetchWorkspaceInfo()
    }
    
    func saveWorksapce(data:Workspace) {
        userRepository.saveWorkspace(data: data)
    }
    
    func loadTodayMeeting() -> Observable<TodayMeetings?> {
        return meetingRepository.loadTodayMeeting()
    }
    
}
