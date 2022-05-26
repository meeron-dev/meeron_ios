//
//  WorkspaceManagementViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/04.
//

import Foundation
import UIKit

class WorkspaceManagementViewController:UIViewController {
    
    @IBOutlet weak var workspaceLinkLabel: UILabel!
    @IBOutlet weak var workspaceLinkCopyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        guard let workspaceId = UserDefaults.standard.string(forKey: "workspaceId") else  {return}
        createWorkspaceDynamicLink(workspaceId: workspaceId)
        
    }
    
    func addTapper() {
        workspaceLinkCopyLabel.isUserInteractionEnabled = true
        let copyTapper = UITapGestureRecognizer()
        copyTapper.addTarget(self, action: #selector(copyWorkspaceLink))
        workspaceLinkCopyLabel.addGestureRecognizer(copyTapper)
    }
    
    @objc func copyWorkspaceLink() {
        UIPasteboard.general.string = workspaceLinkLabel.text
    }
    
    func createWorkspaceDynamicLink(workspaceId:String) {
        
        WorkspaceCreationRepository().createWorkspaceDynamicLink(workspaceId: Int(workspaceId)!) { urlString in
            if let urlString = urlString {
                self.setWorkspaceLink(url: urlString)
            }
        }
        
    }
    
    func setWorkspaceLink(url:String) {
        
        DispatchQueue.main.async {
            self.addTapper()
            self.workspaceLinkLabel.text = url
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
