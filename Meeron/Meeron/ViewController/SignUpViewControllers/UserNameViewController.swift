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
        
        addTapper()
        configureUI()
        bindVM()
        setupTextField()
    }
    
    func bindVM() {
        userNameVM.successPatchNameSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, success in
                if success {
                    owner.goIntroductionView()
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
                    if text.count > 5 {
                        owner.nameTextField.text = String(text.prefix(5))
                        owner.nameTextField.resignFirstResponder()
                    }
                }else {
                    owner.nameLimitLabelWith.constant = 80
                    owner.doneButton.isEnabled = false
                }
            }).disposed(by: disposeBag)
    }
    
    func configureUI() {
        doneButton.addShadow()
    }
    
    func addTapper() {
        let tapper = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tapper)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func goIntroductionView() {
        let pickCreationParticipationVC = self.storyboard?.instantiateViewController(withIdentifier: "PickCreationParticipationViewController") as! PickCreationParticipationViewController
        
        present(pickCreationParticipationVC, animated: true, completion: nil)
        
        /*
        let introductionVC = self.storyboard?.instantiateViewController(withIdentifier: "IntroductionViewController") as! IntroductionViewController
        
        introductionVC.modalPresentationStyle = .fullScreen
        
        introductionVC.introductions = [
            Introduction(title1: nameTextField.text!, title2: "님,",title3: "이제 회의는 걱정마세요",title4: "", subTitle: "똑똑한 회의 관리, 미론과 함께", description1: "회의 준비부터 마무리까지 맡겨 주세요", description2: "", imageName: "illustration_onboarding_1", backGroundImageName: ""),
            Introduction(title1: "", title2: "출근 전", title3: "", title4: "1분이면 충분해요", subTitle: "주어진 회의를 한눈에", description1: "캘린더와 회의카드로 회의 일정을", description2: "확인하고 준비해보아요", imageName: "illustration_onboarding_2", backGroundImageName: ""),
            Introduction(title1: "", title2: "실속 없는", title3: "회의는", title4:" 그만", subTitle: "모두에게 명확한 회의", description1: "회의 전에 정보를 숙지하고,", description2: "본인의 상태를 공유할 수 있어요", imageName: "illustration_onboarding_3", backGroundImageName: "circle+triangle+X"),
            Introduction(title1: "", title2: "마무리까지", title3: "", title4: "완벽하게", subTitle: "이번 회의도 문제없이", description1: "회의 결과를 확인하고", description2: "부담없이 피드백을 남겨보아요", imageName: "illustration_onboarding_4", backGroundImageName: "")]
        
        present(introductionVC, animated: true, completion: nil)*/
    }
    
    @IBAction func done(_ sender:Any) {
        userNameVM.patchUserName(name: nameTextField.text!)
    }
}
