//
//  UserNameViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/19.
//

import Foundation
import RxSwift

class UserNameViewModel {
    
    let saveUserNameUseCase = SaveUserNameUseCase()
    
    let successPatchNameSubject = BehaviorSubject<Bool>(value: false)
    
    let disposeBag = DisposeBag()
    
    func patchUserName(name:String) {
        saveUserNameUseCase
            .execute(name: name)
            .withUnretained(self)
            .subscribe(onNext: { owner, success in
                owner.successPatchNameSubject.onNext(success)
                if success {
                    UserDefaults.standard.set(name, forKey: "userName")
                }
            }).disposed(by: disposeBag)
    }
}
