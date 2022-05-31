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

class LoginUseCase {
    private let tokenRepository = DefaultTokenRepository()
    private let loginRepository = DefaultLoginRepository()
    
    func loginByKakao() -> Observable<KakaoSDKAuth.OAuthToken>? {
        return loginRepository.loginByKakao()
    }
    
    func getKakaoUserInfo() -> Single<KakaoSDKUser.User> {
        return loginRepository.getKakaoUserInfo()
    }
    
    func execute(email: String, nickname: String?, profileImageUrl: String?, provider: String) -> Observable<Token?> {
        return tokenRepository.fetchLoginToken(email: email, nickname: nickname, profileImageUrl: profileImageUrl, provider: provider)
    }
    
}
