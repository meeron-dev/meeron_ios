//
//  UserNameViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/19.
//

import Foundation
import RxSwift

class UserNameViewModel {
    
    let signUpRepository = DefaultSignUpRepository()
    
    let successPatchNameSubject = BehaviorSubject<Bool>(value: false)
    
    let disposeBag = DisposeBag()
    
    func patchUserName(name:String) {
        signUpRepository.saveUserName(name: name)
            .withUnretained(self)
            .subscribe(onNext: { owner, success in
                if success {
                    UserDefaults.standard.set(name, forKey: "userName")
                    owner.successPatchNameSubject.onNext(success)
                }
            }).disposed(by: disposeBag)
    }
}
