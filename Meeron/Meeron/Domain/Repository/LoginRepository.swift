//
//  LoginRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/20.
//

import Foundation
import RxSwift
import KakaoSDKUser
import RxKakaoSDKUser
import KakaoSDKAuth

protocol LoginRepository {
    func loginByKakao() -> Observable<KakaoSDKAuth.OAuthToken>?
    func getKakaoUserInfo() -> Single<KakaoSDKUser.User>
}
