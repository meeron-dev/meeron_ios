//
//  MeetingParticipantProfileCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/01.
//

import UIKit

class MeetingParticipantProfileCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }

}
