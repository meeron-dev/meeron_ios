//
//  MeetingBaiscInfoCreationViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/03.
//

import Foundation
import UIKit
import RxSwift

class MeetingBaiscInfoCreationViewController: UIViewController {
    
    @IBOutlet weak var prevButton:UIButton!
    @IBOutlet weak var nextButton:UIButton!
    
    @IBOutlet weak var meetingDateLabel:UILabel!
    @IBOutlet weak var meetingTimeLabel:UILabel!
    
    @IBOutlet weak var bringMeetingInfoButton:UIButton!
    
    @IBOutlet weak var meetingTitleTextField:UITextField!
    @IBOutlet weak var meetingNatureTextField:UITextField!
    
    @IBOutlet weak var meetingManagersLabel:UILabel!
    @IBOutlet weak var meetingTeamLabel:UILabel!
    
    @IBOutlet weak var basicInfoContentView:UIView!
    
    @IBOutlet weak var meetingTitleTextLimitLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var meetingNatureTextLimitLabelWidth: NSLayoutConstraint!
    
    @IBOutlet weak var basicInfoScrollView: UIScrollView!
    var scrollViewOriginalOffset = CGPoint(x: 0, y: 0)
    
    let meetingBaiscInfoCreationVM = MeetingBaiscInfoCreationViewModel()
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupKeyboardNoti()
    }
    
    private func configureUI() {
        self.navigationItem.titleView = UILabel.meetingCreationNavigationItemTitleLabel
        
        prevButton.addShadow()
        nextButton.addShadow()
        addTapGesture()
        configureTextField()
        
    }
    
    func setupKeyboardNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        scrollViewOriginalOffset = basicInfoScrollView.contentOffset
        basicInfoScrollView.setContentOffset(CGPoint(x: 0, y: 250+scrollViewOriginalOffset.y), animated: true)
        
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        basicInfoScrollView.setContentOffset(scrollViewOriginalOffset, animated: true)
    }
    
    private func configureTextField() {
        meetingTitleTextField.rx.text.orEmpty
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
            if text != "" {
                owner.meetingTitleTextLimitLabelWidth.constant = 0
                if text.count > 35 {
                    owner.meetingTitleTextField.text = String(text.prefix(35))
                    owner.meetingTitleTextField.resignFirstResponder()
                }
            }else{
                owner.meetingTitleTextLimitLabelWidth.constant = 80
            }
        }).disposed(by: disposeBag)
        
        meetingNatureTextField.rx.text.orEmpty
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { owner, text in
                if text != "" {
                    owner.meetingNatureTextLimitLabelWidth.constant = 0
                    if text.count > 10 {
                        owner.meetingNatureTextField.text = String(text.prefix(10))
                        owner.meetingNatureTextField.resignFirstResponder()
                    }
                }else{
                    owner.meetingNatureTextLimitLabelWidth.constant = 80
                }
            }).disposed(by: disposeBag)
        
    }
    
    
    
    func addTapGesture() {
        let managersTapGesture = UITapGestureRecognizer()
        managersTapGesture.addTarget(self, action: #selector(showManagerSelectView))
        meetingManagersLabel.isUserInteractionEnabled = true
        meetingManagersLabel.addGestureRecognizer(managersTapGesture)
        
        let teamTapGesture = UITapGestureRecognizer()
        teamTapGesture.addTarget(self, action: #selector(showTeamSelectView))
        meetingTeamLabel.isUserInteractionEnabled = true
        meetingTeamLabel.addGestureRecognizer(teamTapGesture)
        
        
        let tapper = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tapper)
    }
    
    @objc func showManagerSelectView() {
        let managerSelectVC = self.storyboard?.instantiateViewController(withIdentifier: "MeetingProfileSelectViewController") as! MeetingProfileSelectViewController
        managerSelectVC.delegate = self
        
        managerSelectVC.modalPresentationStyle = .custom
        managerSelectVC.transitioningDelegate = self
        present(managerSelectVC, animated: true, completion: nil)
        
    }
    
    @objc func showTeamSelectView() {
        let teamSelectVC = self.storyboard?.instantiateViewController(withIdentifier: "MeetingTeamSelectViewController") as! MeetingTeamSelectViewController
        teamSelectVC.delegate = self
        
        teamSelectVC.modalPresentationStyle = .custom
        teamSelectVC.transitioningDelegate = self
        present(teamSelectVC, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func exitMeeingCreation(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MeetingBaiscInfoCreationViewController:UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SelectItemModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension MeetingBaiscInfoCreationViewController:MeetingProfileSelectViewControllerDelegate {
    func passSelectedProfiles(selectedProfiles: [WorkspaceUser]) {
        meetingBaiscInfoCreationVM.setManagers(datas: selectedProfiles)
        let managerNames = meetingBaiscInfoCreationVM.getManagerNames(datas: selectedProfiles)
        meetingManagersLabel.text = managerNames.joined(separator: ", ")
    }
    
}

extension MeetingBaiscInfoCreationViewController: MeetingTeamSelectViewControllerDelegate {
    func passSelectedTeam(data: Team?) {
        meetingBaiscInfoCreationVM.setTeam(data: data)
        if data == nil {
            meetingTeamLabel.text = ""
        }else {
            meetingTeamLabel.text = data?.teamName
        }
    }
}
