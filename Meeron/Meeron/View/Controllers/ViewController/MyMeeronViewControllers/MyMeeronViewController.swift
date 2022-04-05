//
//  MyMeeronViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/03.
//

import Foundation
import UIKit
import SafariServices

class MyMeeronViewController:UIViewController {
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = UserDefaults.standard.string(forKey: "userName")
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func goProfileCreationView(_ sender: Any) {
        guard let workspaceId = UserDefaults.standard.string(forKey: "workspaceId") else {return }
        let workspaceParicipationProfileCreationVC = WorkspaceParicipationProfileCreationViewController(nibName: "WorkspaceParicipationProfileCreationViewController", bundle: nil)
        workspaceParicipationProfileCreationVC.workspaceParicipationProfileCreationVM = WorkspaceParicipationProfileCreationViewModel(workspaceId: workspaceId, type: .myMeeron)
        self.navigationController?.pushViewController(workspaceParicipationProfileCreationVC, animated: true)
    }
    
    
    @IBAction func goTermAgreeView(_ sender: Any) {
        let url = URL(string: URLConstant.terms)!
        let termAgreeSafariView = SFSafariViewController(url: url)
        present(termAgreeSafariView, animated: true, completion: nil)
    }
    
    @IBAction func goPersonalInformationCollectionAgreeView(_ sender: Any) {
        let url = URL(string: URLConstant.personalInformationCollection)!
        let personalInformationCollectionAgreeSafariView = SFSafariViewController(url: url)
        present(personalInformationCollectionAgreeSafariView, animated: true, completion: nil)
    }
}
