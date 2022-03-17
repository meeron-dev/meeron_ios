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
        
        meetingTitleLabel.text = meetingCreationData?.title
        meetingDateLabel.text = meetingCreationData?.date.toKoreanDateString()
        meetingPurposeLabel.text = meetingCreationData?.purpose
        if meetingCreationData?.managers.count == 0 {
            meetingManagersLabel.text = (UserDefaults.standard.string(forKey: "workspaceNickname") ?? "회의 생성자")
        }else {
            meetingManagersLabel.text = (UserDefaults.standard.string(forKey: "workspaceNickname") ?? "회의 생성자") + " 외 \(meetingCreationData?.managers.count ?? 0)명"
        }
        meetingParticipantCountLabel.text = "\((meetingCreationData?.participants.count ?? 0) + (meetingCreationData?.managers.count ?? 0) + 1)명"
        meetingTeamLabel.text = meetingCreationData?.team?.teamName
        if meetingCreationData?.agendas.count ?? -1 > 0 {
            meetingAgendaLabel.text = meetingCreationData?.agendas[0].title
        }
        
        
    }
    
    func setMeetingCreationData(data:MeetingCreation) {
        
        
        
    }
    
    @IBAction func done(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
