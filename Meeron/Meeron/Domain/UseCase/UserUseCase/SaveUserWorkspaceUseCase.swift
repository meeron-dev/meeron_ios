//
//  SaveUserWorkspaceUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/27.
//

import Foundation

class SaveUserWorkspaceUseCase {
    private let userRepository = DefaultUserRepository()
    
    func execute(data:[MyWorkspaceUser]) {
        userRepository.saveUserWorkspace(data: data)
        
    }
    
}
