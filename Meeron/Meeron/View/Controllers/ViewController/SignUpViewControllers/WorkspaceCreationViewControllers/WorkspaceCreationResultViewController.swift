//
//  WorkspaceCreationResultViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/21.
//

import Foundation
import UIKit


class WorkspaceCreationResultViewController:UIViewController {
    
    @IBOutlet weak var nextButton:UIButton!
    
    @IBOutlet weak var workspaceLinkLabel:UILabel!
    @IBOutlet weak var copyLabel:UILabel!
    
    var workspaceLink:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addTapper()
    }
    
    private func configureUI() {
        workspaceLinkLabel.text = workspaceLink
        nextButton.addShadow()
    }
    
    private func addTapper() {
        copyLabel.isUserInteractionEnabled = true
        let copyTapper = UITapGestureRecognizer()
        copyTapper.addTarget(self, action: #selector(copyWorkspaceLink))
        
        copyLabel.addGestureRecognizer(copyTapper)
    }
    
    @objc func copyWorkspaceLink() {
        UIPasteboard.general.string = workspaceLink
    }
    
    @IBAction func goIntroductionView(_ sender: Any) {
        let introductionVC = IntroductionViewController(nibName: "IntroductionViewController", bundle: nil)
        introductionVC.modalPresentationStyle = .fullScreen
        present(introductionVC, animated: true, completion: nil)
    }
    
    
    
}
