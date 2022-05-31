//
//  SaveUserNameUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/31.
//

import Foundation
import RxSwift

class SaveUserNameUseCase {
    let userRepository = DefaultUserRepository()
    func execute(name:String) -> Observable<Bool> {
        return userRepository.saveUserName(name: name)
    }
}
