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
    
    @IBOutlet weak var BasicInfoContentView:UIView!
    
    
    @IBOutlet weak var meetingTitleTextLimitLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var meetingNatureTextLimitLabelWidth: NSLayoutConstraint!
    
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        self.navigationItem.titleView = UILabel.meetingCreationNavigationItemTitleLabel
        
        prevButton.addShadow()
        nextButton.addShadow()
        //addPlaceholder()
        addTapGesture()
        configureTextField()
        
        
    }
    
    private func configureTextField() {
        meetingTitleTextField.rx.text.subscribe(onNext: {
            if $0 != "" {
                self.meetingTitleTextLimitLabelWidth.constant = 0
            }else{
                self.meetingTitleTextLimitLabelWidth.constant = 80
            }
        }).disposed(by: disposeBag)
        
        meetingNatureTextField.rx.text.subscribe(onNext: {
            if $0 != "" {
                self.meetingNatureTextLimitLabelWidth.constant = 0
            }else{
                self.meetingNatureTextLimitLabelWidth.constant = 80
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func addPlaceholder() {
        //meetingTitleTextField.placeholder = "필수 입력 정보입니다."
        //meetingNatureTextField.placeholder = "필수 입력 정보입니다."
        let attribute = NSAttributedString(string: "필수 입력 정보입니다.", attributes: [.foregroundColor:UIColor(red: 129, green: 129, blue: 129, alpha: 100), .font:UIFont(name: "AppleSDGothicNeo-Regular", size: 16)!])
        meetingTitleTextField.attributedPlaceholder = attribute
        //meetingNatureTextField.attributedPlaceholder = attribute
        
    }
    
    func addTapGesture() {
        let managersTapGesture = UITapGestureRecognizer()
        managersTapGesture.addTarget(self, action: #selector(showManagerSelectView))
        meetingManagersLabel.isUserInteractionEnabled = true
        meetingManagersLabel.addGestureRecognizer(managersTapGesture)
        
        let teamTapGesture = UITapGestureRecognizer()
        managersTapGesture.addTarget(self, action: #selector(showTeamSelectView))
        meetingTeamLabel.isUserInteractionEnabled = true
        meetingTeamLabel.addGestureRecognizer(teamTapGesture)
        
        
        let tapper = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tapper)
    }
    
    @objc func showManagerSelectView() {
        let managerSelectVC = self.storyboard?.instantiateViewController(withIdentifier: "ManagerSelectViewController") as! ManagerSelectViewController
        managerSelectVC.modalPresentationStyle = .custom
        managerSelectVC.transitioningDelegate = self
        present(managerSelectVC, animated: true, completion: nil)
        
    }
    
    @objc func showTeamSelectView() {
        let timeSelectVC = self.storyboard?.instantiateViewController(withIdentifier: "TimeSelectViewController") as! TimeSelectViewController
        timeSelectVC.modalPresentationStyle = .custom
        timeSelectVC.transitioningDelegate = self
        present(timeSelectVC, animated: true, completion: nil)
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
    
}

extension MeetingBaiscInfoCreationViewController:UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SelectItemModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
