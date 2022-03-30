//
//  TeamNameCreationViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/28.
//

import Foundation
import UIKit
import RxSwift

class TeamNameCreationViewController:UIViewController {
    
    @IBOutlet weak var workspaceNameLabel: UILabel!
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamNameLimitLabelWidth: NSLayoutConstraint!
    
    @IBOutlet weak var nextButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        configureUI()
    }
    
    private func configureUI() {
        nextButton.addShadow()
    }
    
    private func setupTextField() {
        teamNameTextField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                if text.count > TextFieldLimitNumberConstant.workspaceTeamName {
                    owner.teamNameTextField.text = String(text.prefix(TextFieldLimitNumberConstant.workspaceTeamName))
                    owner.teamNameTextField.resignFirstResponder()
                }
    
                if text.trimmingCharacters(in: .whitespaces) != "" {
                    owner.teamNameLimitLabelWidth.constant = 0
                    owner.nextButton.isEnabled = true
                }else {
                    owner.teamNameLimitLabelWidth.constant = 80
                    owner.nextButton.isEnabled = false
                }
                
                    
            }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        guard let teamParticipantCreationVC = segue.destination as? TeamParticipantCreationViewController else {return}
        
        
        teamParticipantCreationVC.teamCreationVM = TeamCreationViewModel(teamName: teamNameTextField.text!)
        
        
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
