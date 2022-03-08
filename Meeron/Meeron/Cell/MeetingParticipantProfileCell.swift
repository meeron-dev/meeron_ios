//
//  ParticipantProfileCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/06.
//

import UIKit

class MeetingParticipantProfileCell: UICollectionViewCell {

    @IBOutlet weak var entireProfileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var profilePositionLabel: UILabel!
    @IBOutlet weak var managerLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    var profileData:WorkspaceUser?
    
    var meetingProfileSelectVM:MeetingProfileSelectViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureUI()
        addTapGesture()
        isDeselected()
    }
    
    private func addTapGesture() {
        let entireProfileTap = UITapGestureRecognizer()
        entireProfileTap.addTarget(self, action: #selector(tapProfile))
        entireProfileView.isUserInteractionEnabled = true
        entireProfileView.addGestureRecognizer(entireProfileTap)
    }
    
    @objc private func tapProfile() {
        if selectedView.backgroundColor == .selectedProfileBlue {
            isDeselected()
        }else {
            isSelected()
        }
    }
    
    func isDeselected() {
        selectedView.backgroundColor = nil
        profileNameLabel.textColor = .black
        profilePositionLabel.textColor = .textBalck
        profileNameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 13)
        profilePositionLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
        
        guard let data = profileData else {return}
        meetingProfileSelectVM?.deleteSelectedProfileUserIds(profile: data)
    }
    
    func isSelected() {
        selectedView.backgroundColor = .selectedProfileBlue
        profileNameLabel.textColor = .mrBlue
        profilePositionLabel.textColor = .mrBlue
        profileNameLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 13)
        profilePositionLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12)
        
        guard let data = profileData else {return}
        meetingProfileSelectVM?.addSelectedProfileUserIds(profile: data)
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
        
        profileImageView.image = UIImage(systemName: "person")
        managerLabel.text = ""
        
        selectedView.backgroundColor = nil
    }
    
    func setData(data:WorkspaceUser, vm:MeetingProfileSelectViewModel) {
        profilePositionLabel.text = data.position
        profileNameLabel.text = data.nickname
        profileData = data
        meetingProfileSelectVM = vm
        
        if meetingProfileSelectVM!.isSelectedProfile(profile: data) {
            selectedView.backgroundColor = .selectedProfileBlue
        }else {
            selectedView.backgroundColor = nil
        }
        
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
        }
        
    }
}
