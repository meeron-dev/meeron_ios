//
//  SignUpUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/20.
//

import Foundation
import RxSwift
import KakaoSDKAuth
import KakaoSDKUser

enum UserSignUpState {
    case login
    case terms
    case userName
    case home
}

protocol LoginUseCase {
    
    func fetchToken(email: String, nickname: String?, profileImageUrl: String?, provider: String) -> Observable<Token?>
    func saveToken(token: Token) -> Bool
    func checkUserSignUpState() -> UserSignUpState
    func loginByKakao() -> Observable<KakaoSDKAuth.OAuthToken>?
    func getKakaoUserInfo() -> Single<KakaoSDKUser.User>
}

class DefaultLoginUseCase: LoginUseCase {
    
    private let signUpRepository = DefaultSignUpRepository()
    
    private let tokenRepository = DefaultTokenRepository()
    
    private let loginRepository = DefaultLoginRepository()
    
    func loginByKakao() -> Observable<KakaoSDKAuth.OAuthToken>? {
        return loginRepository.loginByKakao()
    }
    
    func getKakaoUserInfo() -> Single<KakaoSDKUser.User> {
        return loginRepository.getKakaoUserInfo()
    }
    
    func fetchToken(email: String, nickname: String?, profileImageUrl: String?, provider: String) -> Observable<Token?> {
        return tokenRepository.fetchLoginToken(email: email, nickname: nickname, profileImageUrl: profileImageUrl, provider: provider)
    }
    
    func saveToken(token: Token) -> Bool {
        return tokenRepository.saveToken(token: token)
    }
    
    func checkUserSignUpState() -> UserSignUpState {
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
