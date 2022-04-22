//
//  ParticipantProfileCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/06.
//

import UIKit
import Kingfisher

class MeetingProfileSelectCell: UICollectionViewCell {

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
        
        configureUI()
        deselectProfile()
    }
    
    private func addTapGesture() {
        let entireProfileTap = UITapGestureRecognizer()
        entireProfileTap.addTarget(self, action: #selector(tapProfile))
        entireProfileView.isUserInteractionEnabled = true
        entireProfileView.addGestureRecognizer(entireProfileTap)
    }
    
    @objc private func tapProfile() {
        guard let data = profileData else {return}
        if selectedView.backgroundColor == .selectedProfileBlue {
            deselectProfile()
            meetingProfileSelectVM?.deleteSelectedProfileUserIds(profile: data)
        }else {
            selectProfile()
            meetingProfileSelectVM?.addSelectedProfileUserIds(profile: data)
        }
    }
    
    func deselectProfile() {
        selectedView.backgroundColor = nil
        profileNameLabel.textColor = .textBalck
        profilePositionLabel.textColor = .lightGray
        profileNameLabel.font = UIFont(name: FontNameConstant.medium, size: 13)
        profilePositionLabel.font = UIFont(name: FontNameConstant.medium, size: 12)
    }

    
    func selectProfile() {
        selectedView.backgroundColor = .selectedProfileBlue
        profileNameLabel.textColor = .mrBlue
        profilePositionLabel.textColor = .mrBlue
        profileNameLabel.font = UIFont(name: FontNameConstant.bold, size: 13)
        profilePositionLabel.font = UIFont(name: FontNameConstant.semiBold, size: 12)
        
    }
    
    private func configureUI() {
        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = profileImageView.frame.height/2
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowOpacity = 0.17
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 2.1, height: 2.1)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        selectedView.layer.cornerRadius = profileImageView.frame.height/2
        
        profileImageView.image = UIImage(named: ImageNameConstant.profile)
        managerLabel.text = ""
        profileImageView.contentMode = .scaleAspectFill
        
        selectedView.backgroundColor = nil
    }
    
    func setData(data:WorkspaceUser, vm:MeetingProfileSelectViewModel) {
        profileImageView.image = UIImage(named: ImageNameConstant.profile)
        profilePositionLabel.text = data.position
        profileNameLabel.text = data.nickname
        profileData = data
        meetingProfileSelectVM = vm
        
        if vm.isSelectedProfile(profile: data) {
            selectProfile()
        }else {
            deselectProfile()
        }
        
        if vm.isManager(data: data) || String(data.workspaceUserId) == UserDefaults.standard.string(forKey: "workspaceUserId")! {
            selectProfile()
            managerLabel.text = "관리자"
            entireProfileView.isUserInteractionEnabled = false
        }else {
            managerLabel.text = ""
            entireProfileView.isUserInteractionEnabled = true
            addTapGesture()
        }
        
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
    
    
    func setProfileData(data:WorkspaceUser) {
        profileImageView.image = UIImage(named: ImageNameConstant.profile)
        profilePositionLabel.text = data.position
        profileNameLabel.text = data.nickname
        profileData = data
        managerLabel.text = ""
        
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
}
