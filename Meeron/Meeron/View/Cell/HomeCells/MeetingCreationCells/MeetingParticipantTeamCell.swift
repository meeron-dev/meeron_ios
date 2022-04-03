//
//  MeetingParticipantTeamCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/06.
//

import Foundation
import UIKit

class MeetingParticipantTeamCell:UITableViewCell {
    
    @IBOutlet weak var teamLabel:UILabel!
    
    var teamData:Team?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(data:Team?) {
        teamData = data
        guard let data = data else {
            return
        }
        teamLabel.text = data.teamName
    }
    
    
}
