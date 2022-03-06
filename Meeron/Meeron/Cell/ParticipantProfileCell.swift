//
//  ParticipantProfileCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/06.
//

import UIKit

class ParticipantProfileCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var profilePositionLabel: UILabel!
    @IBOutlet weak var managerLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = profileImageView.frame.height/2
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        selectedView.layer.cornerRadius = profileImageView.frame.height/2
        
        profileImageView.image = UIImage(systemName: "person")
        managerLabel.text = ""
        selectedView.backgroundColor = nil
        
        
    }

}
