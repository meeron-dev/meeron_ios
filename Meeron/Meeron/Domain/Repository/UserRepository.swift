//
//  UserRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/20.
//

import Foundation
import RxSwift

protocol UserRepository {
    func reissueToken() -> Observable<Token?>
    func fetchUser() -> Observable<User?>
    func fetchUserWorkspace(id:Int) -> Observable<UserWorkspace?>
    func saveUserId(id:Int)
    func saveUserWorkspace(data:[MyWorkspaceUser])
    func fetchWorkspaceInfo() -> Observable<Workspace?>
    func saveWorkspace(data:Workspace)
    func fetchWorkspaceUser(workspaceUserId:String) -> Observable<WorkspaceUser?>
    func modifyUserProfile(data: WorkspaceProfile) -> Observable<Bool>
}
