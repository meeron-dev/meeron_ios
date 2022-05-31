//
//  GetUserSignUpStateUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/06/01.
//

import Foundation

enum UserSignUpState {
    case login
    case terms
    case userName
    case home
}

class GetUserSignUpStateUseCase {
    func execute() -> UserSignUpState {
        if let _ = UserDefaults.standard.string(forKey: "userName") {
            return .home
        }else {
            if UserDefaults.standard.bool(forKey: "termsAgree") {
                return .userName
            }
            else {
                return .terms
            }
        }
    }
}
