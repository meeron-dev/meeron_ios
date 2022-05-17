//
//  MeetingProfileDeleteCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/27.
//

import UIKit
import Kingfisher

class MeetingProfileDeleteCell: UICollectionViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var deleteCompletion:((WorkspaceUser)->())!
    var profileData:WorkspaceUser!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = profileImageView.frame.height/2
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
       
        profileImageView.image = UIImage(named: ImageNameConstant.profile)
        profileImageView.contentMode = .scaleAspectFill
    }
    
    @IBAction func deleteProfile(_ sender: Any) {
        deleteCompletion(profileData)
    }
    
    func setData(data:WorkspaceUser, completion: @escaping (WorkspaceUser)->()) {
        deleteCompletion = completion
        nameLabel.text = data.nickname
        positionLabel.text = data.position
        profileData = data
        
        if data.profileImageUrl == "" {
            profileImageView.image = UIImage(named: ImageNameConstant.profile)
            return
        }
        
        if let profileUrl = data.profileImageUrl {
            
            API.getImageResource(url: profileUrl) { imageResource in
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

}
