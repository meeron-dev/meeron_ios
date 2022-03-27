//
//  WorkspaceParicipationProfileCreationViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/24.
//

import Foundation
import RxSwift

class WorkspaceParicipationProfileCreationViewModel {
    
    let vaildNicknameSubject = PublishSubject<Bool>()
    let vaildPositionSubject = BehaviorSubject<Bool>(value: false)
    let vaildWorkspaceSubject = PublishSubject<Bool>()
    let successProfileCreationSubject = BehaviorSubject<Bool>(value: false)
    
    
    
    let workspaceId:String
    
    var workspaceProfileData = WorkspaceProfile()
    
    let workspaceParicipationProfileCreationRepository = WorkspaceParicipationProfileCreationRepository()
    
    let disposeBag = DisposeBag()
    
    init(workspaceId:String) {
        self.workspaceId = workspaceId
    }
    
    func checkWorkspace() {
        workspaceParicipationProfileCreationRepository.checkWorkspace(workspaceId: workspaceId)
            .withUnretained(self)
            .subscribe(onNext: { owner, vaild in
                owner.vaildWorkspaceSubject.onNext(vaild)
            }).disposed(by: disposeBag)
    }
    
    
    func savePosition(position:String) {
        if position.trimmingCharacters(in: .whitespaces) != "" {
            workspaceProfileData.position = position
            vaildPositionSubject.onNext(true)
        }else {
            vaildPositionSubject.onNext(false)
        }
        
    }
    func savePhoneNumber(phoneNumber:String) {
        workspaceProfileData.phoneNumber = phoneNumber
    }
    
    func saveEmail(email:String) {
        workspaceProfileData.email = email
    }
    
    func saveProfileImage(image:Data?) {
        workspaceProfileData.image = image
    }
    
    func checkNickname(nickname:String) {
        if nickname.trimmingCharacters(in: .whitespaces) != "" {
            workspaceParicipationProfileCreationRepository.checkNickname(nickname: nickname, workspaceId: workspaceId)
                .withUnretained(self)
                .subscribe(onNext: { owner, response in
                    if let response = response {
                        if response.duplicate {
                            owner.vaildNicknameSubject.onNext(false)
                        }else {
                            owner.saveNickname(nickname: nickname)
                        }
                    }else {
                        owner.vaildNicknameSubject.onNext(false)
                    }
                }).disposed(by: disposeBag)
        }
    }
    
    func saveNickname(nickname:String) {
        if nickname.trimmingCharacters(in: .whitespaces) != "" {
            workspaceProfileData.nickname = nickname
            vaildNicknameSubject.onNext(true)
        }else {
            vaildNicknameSubject.onNext(false)
        }
        
    }
    
    func createWorkspaceProfile() {
        workspaceParicipationProfileCreationRepository.postProfile(workspaceProfile: workspaceProfileData, workspaceId: workspaceId)
            .withUnretained(self)
            .subscribe(onNext: { owner, success in
                owner.successProfileCreationSubject.onNext(success)
            }).disposed(by: disposeBag)
    }
    
}
