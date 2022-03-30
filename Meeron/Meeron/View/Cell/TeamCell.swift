//
//  TeamCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/26.
//

import Foundation
import UIKit

class TeamCell:UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var teamNameLabel:UILabel!
    
    var teamData:Team?
    var index:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(data:Team?, index:Int) {
        self.index = index
        if index == 0 || index == 6 {
            teamNameLabel.text = ""
        }else {
            if let data = data{
                teamNameLabel.text = String(data.teamName.prefix(2))
                teamData = data
            }
        }
        backgroundImageView.image = UIImage(named: "ic_team_\(index)")
    }
}
