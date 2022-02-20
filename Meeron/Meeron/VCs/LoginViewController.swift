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

class LoginViewController: UIViewController {

    let disposeBag = DisposeBag()
    let loginVM = LoginViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    @IBAction func kakaoLogin(_ sender: Any) {
        loginVM.login()
        loginVM.loginSuccess.subscribe(onNext: {
            if $0 {
                guard let meetingVC = self.storyboard?.instantiateViewController(withIdentifier:"TabBarController") else {
                    return
                    
                }
                        
                meetingVC.modalPresentationStyle = .fullScreen
                meetingVC.modalTransitionStyle = .crossDissolve
                self.present(meetingVC, animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
    
}

