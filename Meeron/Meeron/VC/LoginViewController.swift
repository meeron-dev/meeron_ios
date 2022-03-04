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
    
    @IBOutlet weak var appleLoginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpAppleLoginView()
    }
    
    func setUpAppleLoginView() {
        if #available(iOS 13.0, *) {} else {
            return
        }
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        appleLoginView.addSubview(button)
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @IBAction func kakaoLogin(_ sender: Any) {
        loginVM.loginByKakao()
        loginVM.loginSuccess.subscribe(onNext: {
            $0 ? self.goMeeting() : nil
        }).disposed(by: disposeBag)
    }
    
    func goMeeting() {
        guard let meetingVC = self.storyboard?.instantiateViewController(withIdentifier:"TabBarController") else {
            return
            
        }
                
        meetingVC.modalPresentationStyle = .fullScreen
        meetingVC.modalTransitionStyle = .crossDissolve
        self.present(meetingVC, animated: true, completion: nil)
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
            loginVM.loginSuccess.subscribe(onNext:{
                $0 ? self.goMeeting() : nil
            }).disposed(by: disposeBag)
        }
    }
    
}
