//
//  MeetingTeamSelectCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/06.
//

import Foundation
import UIKit

class MeetingTeamSelectCell:UITableViewCell {
    
    @IBOutlet weak var teamName:UILabel!
    
    var teamData:Team?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setTeamData(data:Team) {
        teamData = data
        teamName.text = data.teamName
    }
    
    func isSelected() -> Bool {
        if teamName.textColor == .mrBlue {
            isDeseleted()
            return false
        }
        teamName.textColor = .mrBlue
        teamName.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 19)
        return true
    }
    
    func isDeseleted() {
        teamName.textColor = .textBalck
        teamName.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 19)
    }
}
