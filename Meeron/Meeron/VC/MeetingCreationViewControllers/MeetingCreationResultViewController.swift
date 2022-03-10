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
    
    @IBOutlet weak var meetingTitleLabel:UILabel!
    @IBOutlet weak var meetingDateLabel:UILabel!
    @IBOutlet weak var meetingPurposeLabel:UILabel!
    @IBOutlet weak var meetingManagersLabel:UILabel!
    @IBOutlet weak var meetingTeamLabel:UILabel!
    @IBOutlet weak var meetingAgendaLabel:UILabel!
    @IBOutlet weak var meetingParticipantCountLabel:UILabel!
    
    var meetingCreationData: MeetingCreation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    private func configureUI() {
        self.navigationItem.titleView = UILabel.meetingCreationNavigationItemTitleLabel
        
        okButton.addShadow()
        meetingCreationResultButton.addShadow()
        
    }
    
    func setMeetingCreationData(data:MeetingCreation) {
        meetingTitleLabel.text = data.title
        meetingDateLabel.text = data.date.changeMeetingCreationDateToKoreanString()
        meetingPurposeLabel.text = data.purpose
        if data.managers.count == 1 {
            meetingManagersLabel.text = data.managers[0].nickname
        }else if data.managers.count > 1 {
            meetingManagersLabel.text = data.managers[0].nickname + "외 \(data.managers.count - 1)명"
        }
        
    }
}
