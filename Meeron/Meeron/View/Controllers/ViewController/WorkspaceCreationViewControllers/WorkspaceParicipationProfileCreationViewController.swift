//
//  WorkspaceParicipationProfileCreationViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/22.
//

import Foundation
import UIKit
import RxSwift
import PhotosUI

class WorkspaceParicipationProfileCreationViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameCheckLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var positionLimitLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var nicknameLimitLabelWidth: NSLayoutConstraint!
    
    @IBOutlet weak var profileScrollView: UIScrollView!
    var scrollViewOriginalOffset = CGPoint(x: 0, y: 0)
    
    let disposeBag = DisposeBag()
    var workspaceParicipationProfileCreationVM: WorkspaceParicipationProfileCreationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workspaceParicipationProfileCreationVM.checkWorkspace()
        
        configureUI()
        setupButton()
        setupTextField()
        setupKeyboardNoti()
        
    }
    
    func setupKeyboardNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        scrollViewOriginalOffset = profileScrollView.contentOffset
        profileScrollView.setContentOffset(CGPoint(x: 0, y: 250+scrollViewOriginalOffset.y), animated: true)
        
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        profileScrollView.setContentOffset(scrollViewOriginalOffset, animated: true)
    }
    
    private func setupButton() {
        Observable.combineLatest(workspaceParicipationProfileCreationVM.vaildNicknameSubject,workspaceParicipationProfileCreationVM.vaildPositionSubject) {
            $0 && $1
        }
        .bind(to: doneButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.workspaceParicipationProfileCreationVM.createWorkspaceProfile()
            }).disposed(by: disposeBag)
        
        workspaceParicipationProfileCreationVM.successProfileCreationSubject
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, success in
                if success {
                    owner.next()
                }
            }).disposed(by: disposeBag)
    }
    
    private func next() {
        if let _ = UserDefaults.standard.string(forKey: "workspaceId") {
            let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"TabBarController") as! TabBarController
            homeVC.modalPresentationStyle = .fullScreen
            present(homeVC, animated: true, completion: nil)
        }else {
            let introductionVC = IntroductionViewController(nibName: "IntroductionViewController", bundle: nil)
            introductionVC.modalPresentationStyle = .fullScreen
            present(introductionVC, animated: true, completion: nil)
        }
    }
    
    private func setupTextField() {
        
        nicknameTextField.rx.controlEvent([.editingDidEndOnExit])
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.workspaceParicipationProfileCreationVM.checkNickname(nickname: owner.nicknameTextField.text ?? "")
            }.disposed(by: disposeBag)
        
        
        nicknameTextField.rx.text.orEmpty
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, text in
                if text.count > TextFieldLimitNumberConstant.workspaceProfileNickname {
                    owner.nicknameTextField.text = String(text.prefix(TextFieldLimitNumberConstant.workspaceProfileNickname ))
                    owner.nicknameTextField.resignFirstResponder()
                }
                if text != "" {
                    owner.nicknameLimitLabelWidth.constant = 0
                }else {
                    owner.nicknameLimitLabelWidth.constant = 80
                }
            }).disposed(by: disposeBag)
        
        positionTextField.rx.text.orEmpty
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, text in
                if text.count > TextFieldLimitNumberConstant.workspaceProfilePosition {
                    owner.positionTextField.text = String(text.prefix(TextFieldLimitNumberConstant.workspaceProfilePosition ))
                    owner.positionTextField.resignFirstResponder()
                }
                if text != "" {
                    owner.positionLimitLabelWidth.constant = 0
                }else {
                    owner.positionLimitLabelWidth.constant = 80
                }
                owner.workspaceParicipationProfileCreationVM.savePosition(position: text)
            }).disposed(by: disposeBag)
        
        phoneNumberTextField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                owner.workspaceParicipationProfileCreationVM.savePhoneNumber(phoneNumber: text)
            }).disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                owner.workspaceParicipationProfileCreationVM.saveEmail(email: text)
            }).disposed(by: disposeBag)
    }
    func goErrorView() {
        let workspaceErrorVC = WorkspaceErrorViewController(nibName: "WorkspaceErrorViewController", bundle: nil)
        workspaceErrorVC.modalPresentationStyle = .fullScreen
        present(workspaceErrorVC, animated: true, completion: nil)
    }
    
    private func configureUI() {
        
        workspaceParicipationProfileCreationVM.vaildWorkspaceSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, vaild in
                if !vaild {
                    owner.goErrorView()
                }
            }).disposed(by: disposeBag)
        
        
        doneButton.addShadow()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        profileImageView.contentMode = .scaleAspectFill
        
        let imagePickerTapper = UITapGestureRecognizer()
        imagePickerTapper.addTarget(self, action: #selector(checkPhotoPermission))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imagePickerTapper)
        
        workspaceParicipationProfileCreationVM.vaildNicknameSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, vaild in
                if vaild {
                    owner.nicknameCheckLabelHeight.constant = 0
                }else {
                    owner.nicknameCheckLabelHeight.constant = 20
                }
                
            }).disposed(by: disposeBag)
        
        
    }
    
    @objc func checkPhotoPermission() {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .authorized || status == .limited {
            showImagePickerView()
        }else if status == .denied {
            showAuthorizationDeniedAlert()
        }else if status == .notDetermined{
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    self.checkPhotoPermission()
                }
            }
        }
    }
    
    func showAuthorizationDeniedAlert(){
        let alert = UIAlertController(title: "사진첩 접근 권한을 활성화 해주세요.", message: "프로필 사진을 위해 필요합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "설정으로 가기", style: .default, handler: { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {return}
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func showImagePickerView() {
        var configuartion = PHPickerConfiguration()
        configuartion.filter = .images
        configuartion.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuartion)
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
}

extension WorkspaceParicipationProfileCreationViewController:PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        let itemProvider = results.first?.itemProvider
        
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (item, error) in
                
                let image = item as? UIImage
                if let image = image {
                    self.workspaceParicipationProfileCreationVM.saveProfileImage(image: image.pngData())
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }
            
        }
        picker.dismiss(animated: true)
    }
}
