//
//  MeetingParticipantProfileCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/09.
//

import Foundation
import UIKit
import Kingfisher

class MeetingParticipantProfileCell:UICollectionViewCell {
    
    @IBOutlet weak var profileImageView:UIImageView!
    @IBOutlet weak var profileNameLabel:UILabel!
    @IBOutlet weak var selectedView:UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var profilePositionLabel:UILabel!
    @IBOutlet weak var managerLabel: UILabel!
    
    var profileData:WorkspaceUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    func setData(data:WorkspaceUser?) {
        managerLabel.text = ""
        guard let data = data else {return}
        profileNameLabel.text = data.nickname
        profilePositionLabel.text = data.position
        profileData = data
        
        if data.profileImageUrl == "" {
            profileImageView.image = UIImage(named: ImageNameConstant.profile)
            return
        }
        
        if let profileUrl = data.profileImageUrl {
            
            API().getImageResource(url: profileUrl) { imageResource in
                DispatchQueue.main.async {
                    self.profileImageView.kf.indicatorType = .activity
                    self.profileImageView.kf.setImage(with: imageResource)
                }
            }
            
        }
        if profileImageView.image == nil {
            profileImageView.image = UIImage(named: ImageNameConstant.profile)
        }
        
    }
    
    func deselectProfile() {
        selectedView.backgroundColor = nil
        profileNameLabel.textColor = .black
        profilePositionLabel.textColor = .textBalck
        profileNameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 13)
        profilePositionLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
        
    }

    
    func selectProfile() {
        selectedView.backgroundColor = .selectedProfileBlue
        profileNameLabel.textColor = .mrBlue
        profilePositionLabel.textColor = .mrBlue
        profileNameLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 13)
        profilePositionLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12)
        
    }
    
    private func configureUI() {
        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = profileImageView.frame.height/2
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        selectedView.layer.cornerRadius = profileImageView.frame.height/2
        
        profileImageView.image = UIImage(named: ImageNameConstant.profile)
        managerLabel.text = ""
        profileImageView.contentMode = .scaleAspectFill
        selectedView.backgroundColor = nil
    }
    
}
