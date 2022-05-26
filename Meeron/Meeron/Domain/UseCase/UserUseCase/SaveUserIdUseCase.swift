//
//  SaveUserIdUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/27.
//

import Foundation

class SaveUserIdUseCase {
    private let userRepository = DefaultUserRepository()

    func execute (id:Int) {
        userRepository.saveUserId(id: id)
    }
}
