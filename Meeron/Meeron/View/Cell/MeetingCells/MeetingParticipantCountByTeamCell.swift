//
//  MeetingParticipantCountByTeamCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/02.
//

import Foundation
import UIKit

protocol MeetingParticipantCountByTeamCellProtocol {
    func goMeetingParticipantCountByTeamView(data:ParticipantCountByTeam)
}

class MeetingParticipantCountByTeamCell:UITableViewCell {
    
    @IBOutlet weak var teamNameLabel:UILabel!
    @IBOutlet weak var totalParticipantCountLabel:UILabel!
    @IBOutlet weak var attendanceCountLabel:UILabel!
    @IBOutlet weak var absenceCountLabel:UILabel!
    @IBOutlet weak var unknownCountLabel:UILabel!
    
    var delegate:MeetingParticipantCountByTeamCellProtocol!
    
    var teamId:Int!
    var data:ParticipantCountByTeam!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(data:ParticipantCountByTeam) {
        self.data = data
        teamId = data.teamId
        
        teamNameLabel.text = data.teamName
        
        attendanceCountLabel.text = String(data.attends)
        absenceCountLabel.text = String(data.absents)
        unknownCountLabel.text = String(data.unknowns)
        
        totalParticipantCountLabel.text = "\(data.attends + data.absents + data.unknowns)명 예정"
    }
    
    @IBAction func goMeetingParticipantCountByTeamView(_ sender: Any) {
        delegate.goMeetingParticipantCountByTeamView(data:data)
    }
}
