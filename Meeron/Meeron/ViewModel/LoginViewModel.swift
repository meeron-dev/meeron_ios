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
    let realmStorage = RealmStorage()
    
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
            resource = Resource<Token>(url: URLConstant.login, parameter:["email":"test4@test.com", "nickname":nickname, "profileImageUrl":profileImageUrl,"provider":provider], headers: ["Content-Type": "application/json"], method: .post, encodingType: .JSONEncoding)
        }else{
            resource = Resource<Token>(url: URLConstant.login, parameter:["email":"test4@test.com","provider":provider], headers: ["Content-Type": "application/json"], method: .post, encodingType: .JSONEncoding)
        }
        

        API().requestData(resource: resource)
            .subscribe(onNext: {
                if $0 != nil {
                    self.saveToken(token: $0!)
                }else {
                    self.loginSuccess.onNext(false)
                }
            }).disposed(by: self.disposeBag)
        
    }
    
    func saveToken(token:Token) {
        keychainManager.saveLoginToken(accessToken: token.accessToken, refreshToken: token.refreshToken) ? loadUser() : loginSuccess.onNext(false)
        
    }
    
    func loadUser() {
        let resource = Resource<User>(url: URLConstant.user, parameter:[:], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
        
        API().requestData(resource: resource)
            .subscribe(onNext: { user in
                guard let user = user else {return}
                self.saveUserId(id: user.userId)
                self.loadUserWorkspace(id: user.userId)
            }).disposed(by: disposeBag)
    }
    
    func loadUserWorkspace(id:Int) {
        print("USER ID:,",id)
        let resource = Resource<UserWorkspace>(url: URLConstant.userWorkspace+"/\(id)/workspace-users", parameter: ["userId":String(id)], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
        
        API().requestData(resource: resource)
            .subscribe(onNext: { userWorkspace in
                self.loginSuccess.onNext(true)
                print("USER WORKSPACE", userWorkspace)
                print(userWorkspace)
                guard let userWorkspace  = userWorkspace else  {return}
                if userWorkspace.myWorkspaceUsers.count > 0 {
                    self.saveUserWorkspace(data: userWorkspace.myWorkspaceUsers)
                }
                
            }).disposed(by: disposeBag)
    }
    
    func saveUserId(id:Int) {
        self.realmStorage.storeUserInfo(userId: id)
        UserDefaults.standard.set(String(id), forKey: "userId")
        print("USER ID :", id)
    }
    
    func saveUserWorkspace(data:[MyWorkspaceUser]) {
        UserDefaults.standard.set(String(data[0].workspaceId), forKey:"workspaceId")
        UserDefaults.standard.set(String(data[0].workspaceUserId), forKey: "workspaceUserId")
        UserDefaults.standard.set(data[0].nickname, forKey: "workspaceNickname")
        
    }
}
