//
//  MeetingProfileDeleteCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/27.
//

import UIKit

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
    }
    
    @IBAction func deleteProfile(_ sender: Any) {
        deleteCompletion(profileData)
    }
    
    func setData(data:WorkspaceUser, completion: @escaping (WorkspaceUser)->()) {
        deleteCompletion = completion
        nameLabel.text = data.nickname
        positionLabel.text = data.position
        profileData = data
        /*
        if data.profileImageUrl != nil {
            let imgURL = URL(string: data.profileImageUrl!)!
            DispatchQueue.global().async {
                let imgData = try? Data(contentsOf: imgURL)
                if imgData != nil {
                    DispatchQueue.main.async {
                        self.profileImageView.image = UIImage(data: imgData!)
                    }
                }
            }
        }*/
    }

}
