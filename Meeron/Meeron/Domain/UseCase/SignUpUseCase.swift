//
//  SignUpUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/15.
//

import Foundation
import RxSwift

protocol SignUpUseCase {
    func saveUserName(name:String) -> Observable<Bool>
}

class DefaultSignUpUseCase: SignUpUseCase {
    
    let signUpRepository = DefaultSignUpRepository()
    
    func saveUserName(name:String) -> Observable<Bool> {
        return signUpRepository.saveUserName(name: name)
    }
}
