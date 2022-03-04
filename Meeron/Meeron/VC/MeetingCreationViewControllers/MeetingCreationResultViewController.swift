//
//  MeetingCreationResultViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/03.
//

import Foundation
import UIKit

class MeetingCreationResultViewController:UIViewController {
    
    @IBOutlet weak var okButton:UIButton!
    @IBOutlet weak var meetingCreationResultButton:UIButton!
    
    @IBOutlet weak var meetingTitle:UILabel!
    @IBOutlet weak var meetingDate:UILabel!
    @IBOutlet weak var meetingNature:UILabel!
    @IBOutlet weak var meetingManagers:UILabel!
    @IBOutlet weak var meetingTeam:UILabel!
    @IBOutlet weak var meetingAgenda:UILabel!
    @IBOutlet weak var meetingParticipantCount:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    private func configureUI() {
        self.navigationItem.titleView = UILabel.meetingCreationNavigationItemTitleLabel
        
        okButton.addShadow()
        meetingCreationResultButton.addShadow()
        
    }
}
