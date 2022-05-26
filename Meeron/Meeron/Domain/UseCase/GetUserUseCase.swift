//
//  GetUserUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/26.
//

import Foundation
import RxSwift

class GetUserUseCase {
    private let userRepository = DefaultUserRepository()
    
    func execute() -> Observable<User?> {
        return userRepository.fetchUser()
    }
}
