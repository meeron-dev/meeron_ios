//
//  LoginViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/19.
//

import Foundation
import KakaoSDKUser
import RxKakaoSDKUser
import RxSwift
import JWTDecode


enum UserSignUpState {
    case login
    case terms
    case userName
    case home
}


class LoginViewModel {
    
    let disposeBag = DisposeBag()
    
    let userSignUpStateSubject = PublishSubject<UserSignUpState>()
    
    let keychainManager = KeychainManager()
    let realmStorage = RealmStorage()
    
    let signUpRepository = SignUpRepository()
    
    func loginByKakao() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.rx.loginWithKakaoTalk().subscribe(onNext: { _ in
                self.getKakaoUserInfo()
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
        }
    }
    
    func getEmailByDecodedJWT(jwt:String) -> String? {
        let jwt = try? decode(jwt: jwt)
        return jwt?.body["email"] as? String
    }
    
    func loginByApple(email:String?, name:String?, jwt:String) {
        
        var userEmail = email
        if userEmail == nil {
            userEmail = getEmailByDecodedJWT(jwt: jwt)
        }
        
        guard let userEmail = userEmail else {
            return
        }

        self.loadToken(email: userEmail, nickname: name, profileImageUrl: nil, provider: "APPLE")
    }
    
    func getKakaoUserInfo() {
        UserApi.shared.rx.me()
            .subscribe(onSuccess: { [weak self] user in
                self?.loadToken(email: user.kakaoAccount!.email!, nickname: user.kakaoAccount!.profile!.nickname!, profileImageUrl: "\(user.kakaoAccount!.profile!.profileImageUrl!)",provider: "KAKAO")

            }, onFailure: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    func loadToken(email:String, nickname:String?, profileImageUrl:String?, provider:String) {
        
        signUpRepository.loadLoginToken(email: email, nickname: nickname, profileImageUrl: profileImageUrl, provider: provider)
            .withUnretained(self)
            .subscribe(onNext: { owner, token in
                if let token = token {
                    owner.saveToken(token: token)
                }else {
                    owner.userSignUpStateSubject.onNext(.login)
                }
            }).disposed(by: disposeBag)
        
    }
    
    
    func saveToken(token:Token) {
        if keychainManager.saveLoginToken(accessToken: token.accessToken, refreshToken: token.refreshToken) {
            checkUserSignUpState()
        }else {
            userSignUpStateSubject.onNext(.login)
        }
        
    }
    
    func checkUserSignUpState() {
        if let _ = UserDefaults.standard.string(forKey: "userName") {
            userSignUpStateSubject.onNext(.home)
        }else {
            if UserDefaults.standard.bool(forKey: "termsAgree") {
                userSignUpStateSubject.onNext(.userName)
            }
            else {
                userSignUpStateSubject.onNext(.terms)
            }
        }
    }
}