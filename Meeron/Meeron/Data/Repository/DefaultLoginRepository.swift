//
//  DefaultLoginRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/20.
//

import Foundation
import KakaoSDKUser
import RxKakaoSDKUser
import KakaoSDKAuth
import RxSwift

class DefaultLoginRepository: LoginRepository {
    
    func loginByKakao() -> Observable<KakaoSDKAuth.OAuthToken>? {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk()
        }else {
            return nil
        }
    }
    
    func getKakaoUserInfo() -> Single<KakaoSDKUser.User> {
        return UserApi.shared.rx.me()
    }
}
