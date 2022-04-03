//
//  UserNameViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/19.
//

import Foundation
import UIKit
import RxSwift

class UserNameViewController:UIViewController {
    
    @IBOutlet weak var doneButton:UIButton!
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var nameLimitLabelWith:NSLayoutConstraint!

    
    let userNameVM = UserNameViewModel()
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUI()
        bindVM()
        setupTextField()
    }
    
    func bindVM() {
        userNameVM.successPatchNameSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, success in
                if success {
                    owner.goPickCreationParticipationView()
                }
            }).disposed(by: disposeBag)
    }
    
    func setupTextField() {
        nameTextField.rx.text.orEmpty
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                if text.trimmingCharacters(in: .whitespaces) != "" {
                    owner.doneButton.isEnabled = true
                    owner.nameLimitLabelWith.constant = 0
                }else {
                    owner.nameLimitLabelWith.constant = 80
                    owner.doneButton.isEnabled = false
                }
                if text.count > TextFieldLimitNumberConstant.userName {
                    owner.nameTextField.text = String(text.prefix(TextFieldLimitNumberConstant.userName))
                    owner.nameTextField.resignFirstResponder()
                }
            }).disposed(by: disposeBag)
    }
    
    func configureUI() {
        doneButton.addShadow()
        addDismissKeyboardTapper()
    }
    
    
    func goPickCreationParticipationView() {
        let pickCreationParticipationVC = self.storyboard?.instantiateViewController(withIdentifier: "PickCreationParticipationViewController") as! PickCreationParticipationViewController
        pickCreationParticipationVC.modalPresentationStyle = .fullScreen
        present(pickCreationParticipationVC, animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender:Any) {
        userNameVM.patchUserName(name: nameTextField.text!)
    }
}
