//
//  UserAccountManagementViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/04.
//

import Foundation
import Alamofire
import RxSwift

class UserAccountManagementViewModel {
    
    let authRepository = AuthRepository()
    let logoutSubject = BehaviorSubject<Bool>(value: false)
    let withdrawSubject = BehaviorSubject<Bool>(value: false)
    let disposeBag = DisposeBag()
    func logout() {
        authRepository.logout()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.deleteToken()
                owner.logoutSubject.onNext(true)
            }).disposed(by: disposeBag)
            
    }
    
    func deleteToken() {
        authRepository.deleteToken()
    }
    
    func deleteUserInfo() {
        authRepository.deleteUserInfo()
    }
    
    func withdraw() {
        authRepository.withdraw()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.deleteToken()
                owner.deleteUserInfo()
                owner.withdrawSubject.onNext(true)
            }).disposed(by: disposeBag)
    }
}
