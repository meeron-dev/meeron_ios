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


class LoginViewModel {
    
    let disposeBag = DisposeBag()
    
    let loginSuccess = PublishSubject<Bool>()
    
    let keychainManager = KeychainManager()
    
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
            .subscribe(onSuccess: { user in
                self.loadToken(email: user.kakaoAccount!.email!, nickname: user.kakaoAccount!.profile!.nickname!, profileImageUrl: "\(user.kakaoAccount!.profile!.profileImageUrl!)",provider: "KAKAO")

            }, onFailure: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    func loadToken(email:String, nickname:String?, profileImageUrl:String?, provider:String) {
        let resource:Resource<Token>
        
        if let nickname = nickname, let profileImageUrl = profileImageUrl{
            resource = Resource<Token>(url: "https://dev.meeron.net/api/login", parameter:["email":email, "nickname":nickname, "profileImageUrl":profileImageUrl,"provider":provider], headers: ["Content-Type": "application/json"], method: .post)
        }else{
            resource = Resource<Token>(url: "https://dev.meeron.net/api/login", parameter:["email":email,"provider":provider], headers: ["Content-Type": "application/json"], method: .post)
        }
        

        API().load(resource: resource)
            .subscribe(onNext: {
                if $0 != nil {
                    self.saveToken(token: $0!)
                }else {
                    self.loginSuccess.onNext(false)
                }
            }).disposed(by: self.disposeBag)
        
    }
    
    func saveToken(token:Token) {
        keychainManager.saveLoginToken(accessToken: token.accessToken, refreshToken: token.refreshToken) ? loginSuccess.onNext(true) : loginSuccess.onNext(false)
        
    }
}
