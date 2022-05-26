//
//  UserAccountManagementViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/04.
//

import Foundation
import UIKit
import RxSwift
class UserAccountManagementViewController:UIViewController {
    
    
    let userAccountManagementVM = UserAccountManagementViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        
        userAccountManagementVM.withdrawSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, success in
                if success {
                    owner.showDoneWithdrawPopUp()
                }
            }).disposed(by: disposeBag)
        
        userAccountManagementVM.logoutSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, success in
                if success {
                    owner.showDoneLogoutPopup()
                }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func logout(_ sender:Any) {
        
        showTwoButtonPopUpView(message: "로그아웃하시겠습니까?", subMessage: "", hasWorksapceLabel: false, leftButtonTitle: "취소", rightButtonTitle: "로그아웃", leftComletion: {}, rightCompletion: {
            self.userAccountManagementVM.logout()
        })
        
    }
    
    func showDoneLogoutPopup() {
        showOneButtonPopUpView(message: "로그아웃되셨습니다.", hasWorkspaceLabel: false, doneButtonTitle: "확인") {
            self.goLoginView()
        }
    }
    
    func goLoginView() {
        dismiss(animated: false, completion: nil)
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        loginVC?.modalPresentationStyle = .fullScreen
        
        present(loginVC!, animated: false, completion: nil)
    }
    
    @IBAction func withdraw(_ sender:Any) {
        if UserDefaults.standard.bool(forKey: "workspaceAdmin") {
            showTwoButtonPopUpView(message: "정말 회원 탈퇴하시겠습니까?", subMessage: "관리 중인 워크스페이스가 삭제됩니다.", hasWorksapceLabel: true, leftButtonTitle: "취소", rightButtonTitle: "탈퇴하기", leftComletion: {}, rightCompletion: {
                self.userAccountManagementVM.withdraw()
            })
        }else {
            showTwoButtonPopUpView(message: "정말 회원 탈퇴하시겠습니까?", subMessage: "저장되어 있던 정보가 삭제될 수 있습니다.", hasWorksapceLabel: true, leftButtonTitle: "취소", rightButtonTitle: "탈퇴하기", leftComletion: {}, rightCompletion: {
                self.userAccountManagementVM.withdraw()
            })
        }
    }
    
    func showDoneWithdrawPopUp() {
        showOneButtonPopUpView(message: "회원 탈퇴 되셨습니다.", hasWorkspaceLabel: true, doneButtonTitle: "확인", doneCompletion: {
            self.goLoginView()
        })
    }
    
    @IBAction func back(_ sender:Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
