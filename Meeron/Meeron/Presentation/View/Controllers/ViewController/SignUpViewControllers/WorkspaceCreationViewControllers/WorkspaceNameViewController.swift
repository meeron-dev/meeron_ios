//
//  WorkspaceNameViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/21.
//

import Foundation
import UIKit
import RxSwift

class WorkspaceNameViewController:UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var workspaceNameTextField: UITextField!
    
    @IBOutlet weak var workspaceNameLimitLabelWidth: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupTextField()
        
      
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func setupTextField() {
        workspaceNameTextField.rx.text.orEmpty
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                
                if text.count > TextFieldLimitNumberConstant.workspaceName {
                    owner.workspaceNameTextField.text = String(text.prefix(TextFieldLimitNumberConstant.workspaceName))
                    owner.workspaceNameTextField.resignFirstResponder()
                }
                
                if text.trimmingCharacters(in: .whitespaces) != "" {
                    owner.workspaceNameLimitLabelWidth.constant = 0
                    owner.nextButton.isEnabled = true
                }else {
                    owner.workspaceNameLimitLabelWidth.constant = 80
                    owner.nextButton.isEnabled = false
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    func configureUI() {
        backButton.addShadow()
        nextButton.addShadow()
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        guard let workspaceProfileCreationVC = segue.destination as? WorkspaceProfileCreationViewController else {return}
        
        var workspaceCreationData = WorkspaceCreation()
        workspaceCreationData.workspaceName = workspaceNameTextField.text!
        
        workspaceProfileCreationVC.workspaceProfileCreationVM = WorkspaceProfileCreationViewModel(workspaceCreationData: workspaceCreationData)
        
    }
    
    
}
