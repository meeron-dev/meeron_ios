//
//  MeetingParticipantCreationViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/03.
//

import Foundation
import UIKit

class MeetingParticipantCreationViewController:UIViewController {
    
    @IBOutlet weak var prevButton:UIButton!
    @IBOutlet weak var nextButton:UIButton!
    
    @IBOutlet weak var meetingDate:UILabel!
    @IBOutlet weak var meetingTime:UILabel!
    @IBOutlet weak var meetingTitle:UILabel!
    
    @IBOutlet weak var participantCountDate:UILabel!
    
    @IBOutlet weak var searchButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    private func configureUI() {
        self.navigationItem.titleView = UILabel.meetingCreationNavigationItemTitleLabel
        
        prevButton.addShadow()
        nextButton.addShadow()
    }
}
