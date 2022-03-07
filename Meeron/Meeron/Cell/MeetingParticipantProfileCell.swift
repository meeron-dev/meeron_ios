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
    
    var profileUserId:Int?
    var meetingProfileSelectVM:MeetingProfileSelectViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureUI()
        addTapGesture()
    }
    
    private func addTapGesture() {
        let entireProfileTap = UITapGestureRecognizer()
        entireProfileTap.addTarget(self, action: #selector(tapProfile))
        entireProfileView.isUserInteractionEnabled = true
        entireProfileView.addGestureRecognizer(entireProfileTap)
    }
    
    @objc private func tapProfile() {
        if selectedView.backgroundColor == UIColor(red: 52/255, green: 153/255, blue: 181/255, alpha: 0.7) {
            selectedView.backgroundColor = nil
            guard let id = profileUserId else {return}
            meetingProfileSelectVM?.deleteSelectedProfileUserIds(id: id)
        }else {
            selectedView.backgroundColor = UIColor(red: 52/255, green: 153/255, blue: 181/255, alpha: 0.7)
            guard let id = profileUserId else {return}
            meetingProfileSelectVM?.addSelectedProfileUserIds(id: id)
        }
    }
    
    private func configureUI() {
        selectedView.backgroundColor = nil
        
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
        profileUserId = data.workspaceUserId
        meetingProfileSelectVM = vm
        
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
