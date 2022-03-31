//
//  MeetingViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/31.
//

import Foundation
import UIKit

class MeetingViewController:UIViewController {
    
    @IBOutlet weak var workspaceLabel:UILabel!
    @IBOutlet weak var meetingTitle:UILabel!
    @IBOutlet weak var meetingTeamLabel:UILabel!
    @IBOutlet weak var managerLabel:UILabel!
    @IBOutlet weak var meetingPurposeLabel:UILabel!
    @IBOutlet weak var meetingDateLabel:UILabel!
    @IBOutlet weak var meetingTimeLabel:UILabel!
    
    @IBOutlet weak var agendaCheckCountLabel:UILabel!
    @IBOutlet weak var documentCountLabel:UILabel!
    @IBOutlet weak var meetingResultCheckCountLabel:UILabel!
    
    @IBOutlet weak var participantsCountLabel:UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        if #available(iOS 13, *) {
            view.addSubview(UIView.statusBar)
        }
    }
    
    @IBAction func goUserStatusCrationView(_ sender: Any) {
        let userStatusCreationVC = UserStatusCreationViewController(nibName: "UserStatusCreationViewController", bundle: nil)
        userStatusCreationVC.modalPresentationStyle = .fullScreen
        userStatusCreationVC.present(userStatusCreationVC, animated: true, completion: nil)
    }
    
    
    @IBAction func back(_ sender:Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
