//
//  GetUserWorkspaceUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/27.
//

import Foundation
import RxSwift

class GetUserWorkspaceUseCase {
    private let userRepository = DefaultUserRepository()
    
    func execute(id:Int) -> Observable<[MyWorkspaceUser]?> {
        return userRepository.fetchUserWorkspace(id: id)
    }
}
