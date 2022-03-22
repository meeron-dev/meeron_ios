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
    @IBOutlet weak var meetingPurposeTextField:UITextField!
    
    @IBOutlet weak var meetingManagersLabel:UILabel!
    @IBOutlet weak var meetingCreationManagerLabel: UILabel!
    
    
    @IBOutlet weak var meetingTeamLabel:UILabel!
    
    @IBOutlet weak var basicInfoContentView:UIView!
    
    @IBOutlet weak var meetingTitleTextLimitLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var meetingPurposeTextLimitLabelWidth: NSLayoutConstraint!
    
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
        meetingCreationManagerLabel.text = UserDefaults.standard.string(forKey: "workspaceNickname")
        
        configureButton()
        addTapGesture()
        configureTextField()
        setMeetingCreationData()
        
    }
    
    func setMeetingCreationData() {
        meetingBaiscInfoCreationVM.meetingDateSubject
            .bind(to: meetingDateLabel.rx.text)
            .disposed(by: disposeBag)
        meetingBaiscInfoCreationVM.meetingTimeSubject
            .bind(to: meetingTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configureButton() {
        prevButton.addShadow()
        nextButton.addShadow()
        
        Observable.combineLatest(meetingBaiscInfoCreationVM.validTitleSubject, meetingBaiscInfoCreationVM.validPurposeSubject, meetingBaiscInfoCreationVM.validTeamSubject) {
            $0 && $1 && $2
        }
        .withUnretained(self)
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { owner, valid in
            owner.nextButton.isEnabled = valid
        }).disposed(by: disposeBag)
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
        meetingTitleTextField.attributedPlaceholder = NSAttributedString(string:"필수 입력 정보입니다.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        meetingPurposeTextField.attributedPlaceholder = NSAttributedString(string:"필수 입력 정보입니다.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        
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
                owner.meetingBaiscInfoCreationVM.setTitle(title: text)
            }else{
                owner.meetingTitleTextLimitLabelWidth.constant = 80
                owner.meetingBaiscInfoCreationVM.setTitle(title: "")
            }
        }).disposed(by: disposeBag)
        
        meetingPurposeTextField.rx.text.orEmpty
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { owner, text in
                if text != "" {
                    owner.meetingPurposeTextLimitLabelWidth.constant = 0
                    if text.count > 10 {
                        owner.meetingPurposeTextField.text = String(text.prefix(10))
                        owner.meetingPurposeTextField.resignFirstResponder()
                    }
                    owner.meetingBaiscInfoCreationVM.setPurpose(purpose: owner.meetingPurposeTextField.text!)
                    
                }else{
                    owner.meetingPurposeTextLimitLabelWidth.constant = 80
                    owner.meetingBaiscInfoCreationVM.setPurpose(purpose: "")
                }
            }).disposed(by: disposeBag)
        
    }
    
    func addTapGesture() {
        
        let teamTapGesture = UITapGestureRecognizer()
        teamTapGesture.addTarget(self, action: #selector(showTeamSelectView))
        meetingTeamLabel.isUserInteractionEnabled = true
        meetingTeamLabel.addGestureRecognizer(teamTapGesture)
        
        
        let tapper = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tapper)
    }
    
    @IBAction func showProfileSelectView(_ sender: Any) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let meetingAgendaCreationVC = segue.destination as? MeetingAgendaCreationViewController else { return}
        guard let data = meetingBaiscInfoCreationVM.meetingCreationData else {return}
        meetingAgendaCreationVC.meetingAgendaCreationVM.setMeetingCreationData(data: data)
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
        meetingBaiscInfoCreationVM.setManagers(managers: selectedProfiles)
        let managerNames = meetingBaiscInfoCreationVM.getManagerNames(datas: selectedProfiles)
        meetingCreationManagerLabel.text =  (UserDefaults.standard.string(forKey: "workspaceNickname") ?? "회의 생성자") + ", "
        meetingManagersLabel.text = managerNames.joined(separator: ", ")
    }
    
}

extension MeetingBaiscInfoCreationViewController: MeetingTeamSelectViewControllerDelegate {
    func passSelectedTeam(data: Team?) {
        meetingBaiscInfoCreationVM.setTeam(team: data)
        if data == nil {
            meetingTeamLabel.text = "필수 입력 정보입니다."
            meetingTeamLabel.textColor = .darkGray
        }else {
            meetingTeamLabel.text = data?.teamName
            meetingTeamLabel.textColor = .textBalck
        }
    }
}
