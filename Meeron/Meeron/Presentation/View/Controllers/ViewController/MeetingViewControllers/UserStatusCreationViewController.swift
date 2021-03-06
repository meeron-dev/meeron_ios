//
//  UserStatusCreationViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/29.
//

import UIKit
import RxSwift

class UserStatusCreationViewController: UIViewController {

    @IBOutlet weak var workspaceNameLabel: UILabel!
    
    @IBOutlet weak var meetingTitleLabel: UILabel!
    @IBOutlet weak var attendanceButton: UIButton!
    @IBOutlet weak var absenceButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    var userStatusCreationVM:UserStatusCreationViewModel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupButton()
    }
    
    func setupButton() {
        attendanceButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.tapAttendanceButton()
            }).disposed(by: disposeBag)
        
        absenceButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.tapAbsenceButton()
            }).disposed(by: disposeBag)
    }
    
    func tapAttendanceButton() {
        if attendanceButton.imageView?.image == UIImage(named: ImageNameConstant.activationOfAttendance) {
            attendanceButton.setImage(UIImage(named: ImageNameConstant.inactivationOfAttendance), for: .normal)
            if absenceButton.imageView?.image == UIImage(named: ImageNameConstant.inactivationOfAbsence) {
                doneButton.isEnabled = false
            }
        }else {
            attendanceButton.setImage(UIImage(named: ImageNameConstant.activationOfAttendance), for: .normal)
            absenceButton.setImage(UIImage(named: ImageNameConstant.inactivationOfAbsence), for: .normal)
            doneButton.isEnabled = true
        }
    }
    func tapAbsenceButton() {
        if absenceButton.imageView?.image == UIImage(named: ImageNameConstant.activationOfAbsence) {
            absenceButton.setImage(UIImage(named: ImageNameConstant.inactivationOfAbsence), for: .normal)
            if attendanceButton.imageView?.image == UIImage(named: ImageNameConstant.inactivationOfAttendance) {
                doneButton.isEnabled = false
            }
        }else {
            absenceButton.setImage(UIImage(named: ImageNameConstant.activationOfAbsence), for: .normal)
            attendanceButton.setImage(UIImage(named: ImageNameConstant.inactivationOfAttendance), for: .normal)
            doneButton.isEnabled = true
        }
    }

    func configureUI() {
        
        workspaceNameLabel.text = UserDefaults.standard.string(forKey: "workspaceName")
        meetingTitleLabel.text = userStatusCreationVM.meetingTitle
        
        doneButton.addShadow()
        doneButton.isEnabled = false
        
        doneButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.patchUserStatus()
            }).disposed(by: disposeBag)
    }
    
    func patchUserStatus() {
        if absenceButton.imageView?.image == UIImage(named: ImageNameConstant.activationOfAbsence) {
            userStatusCreationVM.patchUserStatus(status: .absent)
        }else {
            userStatusCreationVM.patchUserStatus(status: .attend)
        }
        dismiss(animated: true)
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
