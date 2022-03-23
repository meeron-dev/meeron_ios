//
//  ViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/19.
//

import UIKit

import RxSwift
import KakaoSDKUser
import RxKakaoSDKUser

import AuthenticationServices

class LoginViewController: UIViewController {

    let disposeBag = DisposeBag()
    let loginVM = LoginViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginVM.loginTypeSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, type in
                owner.goNextView(type: type)
            }).disposed(by: disposeBag)
    }
    
    @IBAction func appleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @IBAction func kakaoLogin(_ sender: Any) {
        loginVM.loginByKakao()
    }
    
    func goNextView(type:LoginType) {
        
        if type == .terms {
            let termsVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            
            termsVC.modalPresentationStyle = .fullScreen
            present(termsVC, animated: true, completion: nil)
        }else if type == .userName {
            let userNameVC = self.storyboard?.instantiateViewController(withIdentifier: "UserNameViewController") as! TermsViewController
            
            userNameVC.modalPresentationStyle = .fullScreen
            present(userNameVC, animated: true, completion: nil)
        }else if type == .home {
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier:"TabBarController") as! TabBarController
                    
            homeVC.modalPresentationStyle = .fullScreen
            homeVC.modalTransitionStyle = .crossDissolve
            present(homeVC, animated: true, completion: nil)
        }
        
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userName = credential.fullName
            let email = credential.email
            let identityToken = credential.identityToken
            var name:String?
            if userName != nil {
                if (userName?.familyName) != nil && userName?.givenName != nil {
                    name = userName!.familyName! + userName!.givenName!
                }
            }
            
            loginVM.loginByApple(email: email, name: name, jwt: String.init(data: identityToken!, encoding: .utf8)!)
        }
    }
    
}
