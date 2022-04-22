//
//  LoginViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/19.
//

import Foundation

import RxSwift
import JWTDecode


class LoginViewModel {
    
    let userSignUpStateSubject = PublishSubject<UserSignUpState>()
    
    let loginUseCase = DefaultLoginUseCase()
    
    let disposeBag = DisposeBag()
    
    
    func loginByKakao() {
        loginUseCase.loginByKakao()?
            .subscribe(onNext: { [weak self] _ in
                self?.getKakaoUserInfo()
            }).disposed(by: disposeBag)
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

        fetchToken(email: userEmail, nickname: name, profileImageUrl: nil, provider: "APPLE")
    }
    
    func getKakaoUserInfo() {
        loginUseCase.getKakaoUserInfo()
            .subscribe(onSuccess: { [weak self] user in
                self?.fetchToken(email: user.kakaoAccount!.email!, nickname: user.kakaoAccount!.profile!.nickname!, profileImageUrl: "\(user.kakaoAccount!.profile!.profileImageUrl!)",provider: "KAKAO")

            }).disposed(by: disposeBag)
    }
    
    func fetchToken(email:String, nickname:String?, profileImageUrl:String?, provider:String) {
        
        loginUseCase.fetchToken(email: email, nickname: nickname, profileImageUrl: profileImageUrl, provider: provider)
            .share()
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
        if loginUseCase.saveToken(token: token) {
            checkUserSignUpState()
        }else {
            userSignUpStateSubject.onNext(.login)
        }
        
    }
    
    func checkUserSignUpState() {
        userSignUpStateSubject.onNext(loginUseCase.checkUserSignUpState())
    }
}
