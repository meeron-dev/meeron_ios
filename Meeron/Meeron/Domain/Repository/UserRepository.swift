//
//  UserRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/20.
//

import Foundation
import RxSwift

protocol UserRepository {
    func saveUserName(name:String) -> Observable<Bool>
    func fetchUser() -> Observable<User?>
    func fetchUserWorkspace(id:Int) -> Observable<[MyWorkspaceUser]?>
    func saveUserId(id:Int)
    func saveUserWorkspace(data:[MyWorkspaceUser])
    func fetchWorkspaceUser(workspaceUserId:String) -> Observable<WorkspaceUser?>
    func modifyUserProfile(data: WorkspaceProfile) -> Observable<Bool>
}
