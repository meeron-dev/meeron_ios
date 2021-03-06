//
//  WorkspaceProfileCreationViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/21.
//

import Foundation
import UIKit
import RxSwift
import PhotosUI


class WorkspaceProfileCreationViewController: UIViewController {
    
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var profileScrollView: UIScrollView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet weak var nicknameLimitLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var positionLimitLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var scrollViewOriginalOffset = CGPoint(x: 0, y: 0)
    
    var workspaceProfileCreationVM: WorkspaceProfileCreationViewModel!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
        setupButton()
        configureUI()
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
        Observable.combineLatest(workspaceProfileCreationVM.vaildNicknameSubject, workspaceProfileCreationVM.vaildPositionSubject) {
            $0 && $1
        }
        .bind(to: nextButton.rx.isEnabled)
        .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prevButton.addShadow()
        nextButton.addShadow()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        profileImageView.contentMode = .scaleAspectFill
        
        let imagePickerTapper = UITapGestureRecognizer()
        imagePickerTapper.addTarget(self, action: #selector(checkPhotoPermission))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imagePickerTapper)
        
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
    
    private func setupTextField() {
        
        addDismissKeyboardTapper()
        nicknameTextField.rx.controlEvent([.editingDidEndOnExit]).subscribe { _ in
            print("nicknameTextField editingDidEndOnExit")
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
                owner.workspaceProfileCreationVM.saveNickname(nickname: text)
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
                owner.workspaceProfileCreationVM.savePosition(position: text)
            }).disposed(by: disposeBag)
        
        phoneNumberTextField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                owner.workspaceProfileCreationVM.savePhoneNumber(phoneNumber: text)
            }).disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                owner.workspaceProfileCreationVM.saveEmail(email: text)
            }).disposed(by: disposeBag)
    }
    
    
    @IBAction func prev(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let teamNameVC = segue.destination as? TeamNameViewController else {return}
        teamNameVC.teamNameVM = TeamNameViewModel(workspaceCreationData: workspaceProfileCreationVM.workspaceCreationData)
        
    }
    
   
}

extension WorkspaceProfileCreationViewController:PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        let itemProvider = results.first?.itemProvider
        
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (item, error) in
                
                let image = item as? UIImage
                if let image = image {
                    self.workspaceProfileCreationVM.saveProfileImage(image: image.jpegData(compressionQuality: 0.8))
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }
            
        }
        picker.dismiss(animated: true)
    }
}
