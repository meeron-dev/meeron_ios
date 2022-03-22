//
//  TeamNameViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/21.
//

import Foundation
import UIKit
import RxSwift

class TeamNameViewController:UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamNameLimitLabelWidth: NSLayoutConstraint!
    
    let teamNameVM = TeamNameViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupButton()
        setupTextField()
    }
    
    private func configureUI() {
        backButton.addShadow()
        doneButton.addShadow()
        
        
    }
    
    private func setupTextField() {
        teamNameTextField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                
                if text.trimmingCharacters(in: .whitespaces) != "" {
                    if text.count > TextFieldLimitNumberConstant.workspaceTeamName {
                        owner.teamNameTextField.text = String(text.prefix(10))
                        owner.teamNameTextField.resignFirstResponder()
                    }
                    owner.teamNameVM.saveTeamName(name: text)
                    owner.doneButton.isEnabled = true
                }else {
                    owner.doneButton.isEnabled = false
                }
                    
            }).disposed(by: disposeBag)
    }
    
    private func setupButton() {
        Observable.combineLatest(teamNameVM.successTeamNamePostSubject
                                 ,teamNameVM.successWorkspaceNamePostSubject
                                 , teamNameVM.successWorksapceInviteLinkSubject) {
            $0 && $1 && $2
        }
        .withUnretained(self)
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { owner, success in
            if success {
                owner.goWorkspaceCreationResultVC()
            }
        }).disposed(by: disposeBag)
    }
    
    func setData(data: WorkspaceCreation) {
        teamNameVM.workspaceCreationData = data
    }
    
    @IBAction func createWorkspace(_ sender: Any) {
        teamNameVM.postWorkspaceName()
    }
    
    func goWorkspaceCreationResultVC() {
        let workspaceCreationResultVC = self.storyboard?.instantiateViewController(withIdentifier: "WorkspaceCreationResultViewController") as! WorkspaceCreationResultViewController
        
        self.navigationController?.pushViewController(workspaceCreationResultVC, animated: true)
        workspaceCreationResultVC.workspaceLink = teamNameVM.workspaceInviteUrlString
    }
    
}
