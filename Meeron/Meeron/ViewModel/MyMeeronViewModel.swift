//
//  MyMeeronViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/07.
//

import Foundation
import RxSwift

class MyMeeronViewModel {
    
    let userProfileImageUrlSubject = BehaviorSubject<String>(value: "")
    let userRepository = UserRepository()
    let workspaceUserRepository = WorkspaceUserRepository()
    let userNameSubject = BehaviorSubject<String>(value:"사용자")
    let disposeBag = DisposeBag()
    
    init() {
        loadUserImageInfo()
        loadUserNameInfo()
    }
    
    
    
    func loadUserImageInfo() {
        guard let workspaceUserId = UserDefaults.standard.string(forKey: "workspaceUserId") else {return}
        
        userRepository.loadWorkspaceUser(workspaceUserId: workspaceUserId)
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                if let data = data{
                    print("🟡", data)
                    owner.userProfileImageUrlSubject.onNext(data.profileImageUrl ?? "")
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    
    
    func loadUserNameInfo() {
        guard let workspaceUserId = UserDefaults.standard.string(forKey: "workspaceUserId") else {return}
        workspaceUserRepository.loadWorkspaceUser(id: Int(workspaceUserId)!)
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                if let data = data {
                    owner.userNameSubject.onNext(data.name ?? "사용자")
                }
            }).disposed(by: disposeBag)
        
    }
}
