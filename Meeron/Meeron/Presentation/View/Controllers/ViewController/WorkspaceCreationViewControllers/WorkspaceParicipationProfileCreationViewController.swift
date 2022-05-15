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
import Kingfisher
import AWSS3

class WorkspaceParicipationProfileCreationViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameCheckLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nicknameTextFieldUnderLineView: UIView!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var positionLimitLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var nicknameLimitLabelWidth: NSLayoutConstraint!
    
    @IBOutlet weak var backButton:UIButton!
    
    @IBOutlet weak var profileScrollView: UIScrollView!
    var scrollViewOriginalOffset = CGPoint(x: 0, y: 0)
    
    let disposeBag = DisposeBag()
    
    var workspaceParicipationProfileCreationVM: WorkspaceParicipationProfileCreationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        if workspaceParicipationProfileCreationVM.profileType == .participant {
            setParticipantUI()
            workspaceParicipationProfileCreationVM.checkWorkspace()
        }else {
            setMyMeeronUI()
            workspaceParicipationProfileCreationVM
                .loadProfileData()
            
        }
        
        configureUI()
        setupButton()
        setupTextField()
        setupKeyboardNoti()
        
    }
    
    func setParticipantUI() {
        backButton.setImage(nil, for: .normal)
    }
    
    func setMyMeeronUI() {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.showPopUpView()
            }).disposed(by: disposeBag)
        
        workspaceParicipationProfileCreationVM.profileDataSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                owner.setProfileData(data: data)
            }).disposed(by: disposeBag)
    }
    
    func setProfileData(data: WorkspaceUser) {
        print("🖌")
        nicknameTextField.text = data.nickname
        positionTextField.text = data.position
        emailTextField.text = data.email
        phoneNumberTextField.text = data.phone
        
        if data.profileImageUrl == "" {
            profileImageView.image = UIImage(named: ImageNameConstant.profile)
            return
        }
        
        if let profileUrl = data.profileImageUrl {
           
            API().getImageResource(url: profileUrl) { imageResource in
                DispatchQueue.main.async {
                    self.profileImageView.kf.indicatorType = .activity
                    self.profileImageView.kf.setImage(with: imageResource)
                }
            }
        }
        if profileImageView.image == nil {
            profileImageView.image = UIImage(named: ImageNameConstant.profile)
        }
    }
    
    func showPopUpView() {
        
        showTwoButtonPopUpView(message: "이 페이지를 정말 나가시겠습니까? 작성한 내용이 반영되지 않습니다.", subMessage: "", hasWorksapceLabel: false, leftButtonTitle: "나가기", rightButtonTitle: "머무르기", leftComletion: {
            self.back()
        }, rightCompletion: {})
        
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
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
        
        if workspaceParicipationProfileCreationVM.profileType == .participant {
            if let _ = UserDefaults.standard.string(forKey: "workspaceId") {
                let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"TabBarController") as! TabBarController
                homeVC.modalPresentationStyle = .fullScreen
                present(homeVC, animated: true, completion: nil)
            }else {
                let introductionVC = IntroductionViewController(nibName: "IntroductionViewController", bundle: nil)
                introductionVC.modalPresentationStyle = .fullScreen
                present(introductionVC, animated: true, completion: nil)
            }
        }else {
            back()
        }
        
    }
    
    private func setupTextField() {
        
        nicknameTextField.rx.text.asDriver()
            .debounce(.milliseconds(500))
            .drive { text in
                self.workspaceParicipationProfileCreationVM.checkNickname(nickname: text ?? "")
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
                if vaild || owner.nicknameTextField.text == "" {
                    owner.nicknameCheckLabelHeight.constant = 0
                    owner.nicknameTextFieldUnderLineView.backgroundColor = .lightGray
                }else {
                    owner.nicknameCheckLabelHeight.constant = 20
                    owner.nicknameTextFieldUnderLineView.backgroundColor = .mrRed
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
                    self.workspaceParicipationProfileCreationVM.saveProfileImage(image: image.jpegData(compressionQuality: 0.7))
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }
            
        }
        picker.dismiss(animated: true)
    }
}
