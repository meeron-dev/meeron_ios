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

class LoginViewModel {
    
    let disposeBag = DisposeBag()
    
    let loginSuccess = PublishSubject<Bool>()
    
    func login() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.rx.loginWithKakaoTalk().subscribe(onNext: { oauthToken in
                print("loginWithKakaoTalk() success ")
                _ = oauthToken
                print(oauthToken)
                self.getUserInfo()
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
        }
    }
    
    func getUserInfo() {
        UserApi.shared.rx.me()
            .subscribe(onSuccess: { user in
                print("me() success")
                print(user)
            
                self.loadToken(email: user.kakaoAccount!.email!, nickname: user.kakaoAccount!.profile!.nickname!, profileImageUrl: "\(user.kakaoAccount!.profile!.profileImageUrl!)")

            }, onFailure: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    func loadToken(email:String, nickname:String, profileImageUrl:String) {
        let resource = Resource<Token>(url: "https://dev.meeron.net/api/login", parameter:["email":email, "nickname":nickname, "profileImageUrl":profileImageUrl,"provider":"KAKAO"], headers: ["Content-Type": "application/json"], method: .post)
        
        API().load(resource: resource)
            .subscribe(onNext: {
                if $0 != nil {
                    self.loginSuccess.onNext(true)
                    self.saveToken(token: $0!)
                }else {
                    self.loginSuccess.onNext(false)
                }
                print($0,"!!!!!!")
            }).disposed(by: self.disposeBag)
        
    }
    
    func saveToken(token:Token) {
        
    }
}
