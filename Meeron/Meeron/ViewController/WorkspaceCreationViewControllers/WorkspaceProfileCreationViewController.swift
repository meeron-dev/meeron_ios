//
//  WorkspaceProfileCreationViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/21.
//

import Foundation
import UIKit

enum WorkspaceProfileCreationType:String {
    case creation
    case participation
}


class WorkspaceProfileCreationViewController: UIViewController {
    
    
    @IBOutlet weak var buttonView: UIView!
    var workspaceProfileCreationType:WorkspaceProfileCreationType = .participation
    
    var workspaceCreationData:WorkspaceCreation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    
    func setupData(workspaceProfileCreationType: WorkspaceProfileCreationType, data:WorkspaceCreation?) {
        if workspaceProfileCreationType == .creation {
            self.workspaceProfileCreationType = .creation
            workspaceCreationData = data
            
        }
    }
    
    func setupButton() {
        
        if workspaceProfileCreationType == .creation {
            print("버튼 생성")
            let prevButton = UIButton(type: .custom)
            let nextButton = UIButton(type: .custom)
            
            prevButton.setTitle("이전", for: .normal)
            prevButton.backgroundColor = .lightGray
            prevButton.addTarget(self, action: #selector(prev), for: .touchUpInside)
            
            self.view.addSubview(prevButton)
    
            prevButton.translatesAutoresizingMaskIntoConstraints = false
            
            nextButton.setTitle("다음", for: .normal)
            nextButton.backgroundColor = .mrDarkBlue
            nextButton.addTarget(self, action: #selector(prev), for: .touchUpInside)
            
            self.view.addSubview(nextButton)
            nextButton.translatesAutoresizingMaskIntoConstraints = false
            
            prevButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 25)
                        .isActive = true
            prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
                        .isActive = true
            prevButton.heightAnchor.constraint(equalToConstant: 57)
                        .isActive = true
            let width = self.view.frame.width / 2 - 36.5
            prevButton.widthAnchor.constraint(equalToConstant: width) = true
            
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 25)
                        .isActive = true
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 30)
                        .isActive = true
            nextButton.heightAnchor.constraint(equalToConstant: 57)
                        .isActive = true
            
            nextButton.widthAnchor.constraint(equalToConstant: view.frame.width/2 - 36.5) = true
        }
    }
    
    @objc func prev() {
        
    }
}
