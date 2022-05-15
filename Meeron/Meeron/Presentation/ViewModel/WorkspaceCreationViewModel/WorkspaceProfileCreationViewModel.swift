//
//  WorkspaceProfileCreationViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/25.
//

import Foundation
import RxSwift

class WorkspaceProfileCreationViewModel {
    
    let vaildNicknameSubject = BehaviorSubject<Bool>(value: false)
    let vaildPositionSubject = BehaviorSubject<Bool>(value: false)
    let successProfileCreationSubject = BehaviorSubject<Bool>(value: false)
    
    var workspaceCreationData: WorkspaceCreation!
    
    init(workspaceCreationData:WorkspaceCreation) {
        self.workspaceCreationData = workspaceCreationData
    }
    
    func saveNickname(nickname:String) {
        if nickname.trimmingCharacters(in: .whitespaces) != "" {
            workspaceCreationData.workspaceProfile.nickname = nickname
            vaildNicknameSubject.onNext(true)
        }else {
            vaildNicknameSubject.onNext(false)
        }
        
    }
    
    func savePosition(position:String) {
        if position.trimmingCharacters(in: .whitespaces) != "" {
            workspaceCreationData.workspaceProfile.position = position
            vaildPositionSubject.onNext(true)
        }else {
            vaildPositionSubject.onNext(false)
        }
        
    }
    func savePhoneNumber(phoneNumber:String) {
        workspaceCreationData.workspaceProfile.phoneNumber = phoneNumber
    }
    
    func saveEmail(email:String) {
        workspaceCreationData.workspaceProfile.email = email
    }
    
    func saveProfileImage(image:Data?) {
        workspaceCreationData.workspaceProfile.image = image
    }
}
