//
//  UserProfileViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/07.
//

import Foundation
import RxSwift

class UserProfileViewModel {
    
    let workspaceUserRepository = WorkspaceUserRepository()
    let userInfoSubject = BehaviorSubject<User>(value: User(userId: 0, loginEmail: "", contactEmail: "", name: "", profileImageUrl: "", phone: ""))
    let disposeBag = DisposeBag()
    
    func loadWorkspaceUserInfo(id:Int) {
        workspaceUserRepository.loadWorkspaceUser(id: id)
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                if let data = data {
                    owner.userInfoSubject.onNext(data)
                }
            }).disposed(by: disposeBag)
        
    }
}
