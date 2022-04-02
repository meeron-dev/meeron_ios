//
//  MeetingParticipantCountByTeamViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/02.
//

import Foundation
import UIKit
import RxSwift

class MeetingParticipantCountViewController: UIViewController {
    
    @IBOutlet weak var teamLabel:UILabel!
    @IBOutlet weak var participantTotalCountLabel:UILabel!
    @IBOutlet weak var attendanceCountLabel:UILabel!
    @IBOutlet weak var absenceCountLabel:UILabel!
    @IBOutlet weak var unknownCountLabel:UILabel!
    
    @IBOutlet weak var attendanceCollectionView:UICollectionView!
    @IBOutlet weak var absenceCollectionView:UICollectionView!
    @IBOutlet weak var unknownCollectionView:UICollectionView!
    
    @IBOutlet weak var noAttendanceLabelWidth:NSLayoutConstraint!
    @IBOutlet weak var noAbsenceLabelWidth:NSLayoutConstraint!
    @IBOutlet weak var noUnknownLabelWidth:NSLayoutConstraint!
    
    var meetingParticipantCountVM: MeetingParticipantCountViewModel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        setupCollectionView()
        setCountInfo()
        
        configureUI()
    }
    
    private func configureUI() {
        self.navigationController?.navigationBar.backgroundColor = .white
        teamLabel.text = meetingParticipantCountVM.participantCountByTeamData.teamName
    }
    
    private func setCountInfo() {
        
        attendanceCountLabel.text = "\(meetingParticipantCountVM.participantCountByTeamData.attends)"
        
        absenceCountLabel.text = "\(meetingParticipantCountVM.participantCountByTeamData.absents)"
        
        unknownCountLabel.text = "\(meetingParticipantCountVM.participantCountByTeamData.unknowns)"
        
        participantTotalCountLabel.text = "\(meetingParticipantCountVM.participantCountByTeamData.attends+meetingParticipantCountVM.participantCountByTeamData.absents+meetingParticipantCountVM.participantCountByTeamData.unknowns)명 예정"
        
        (meetingParticipantCountVM.participantCountByTeamData.attends) > 0 ? (noAttendanceLabelWidth.constant = 0) : (noAttendanceLabelWidth.constant = 220)
        (meetingParticipantCountVM.participantCountByTeamData.absents) > 0 ? (noAbsenceLabelWidth.constant = 0) : (noAbsenceLabelWidth.constant = 220)
        (meetingParticipantCountVM.participantCountByTeamData.unknowns) > 0 ? (noUnknownLabelWidth.constant = 0) : (noUnknownLabelWidth.constant = 220)
    }
    
    private func setupCollectionView() {
        setupCollectionViewLayout()
        
        attendanceCollectionView.register(UINib(nibName: "MeetingProfileSelectCell", bundle: nil), forCellWithReuseIdentifier: "MeetingProfileSelectCell")
        
        meetingParticipantCountVM.attendanceProfilesSubject.bind(to: attendanceCollectionView.rx.items) { collectionView, row, element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingProfileSelectCell", for: IndexPath(row: row, section: 0)) as! MeetingProfileSelectCell
            
            cell.setProfileData(data: element)
            return cell
        }.disposed(by: disposeBag)
        
        
        absenceCollectionView.register(UINib(nibName: "MeetingProfileSelectCell", bundle: nil), forCellWithReuseIdentifier: "MeetingProfileSelectCell")
        
        meetingParticipantCountVM.absenceProfilesSubject.bind(to: absenceCollectionView.rx.items) { collectionView, row, element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingProfileSelectCell", for: IndexPath(row: row, section: 0)) as! MeetingProfileSelectCell
            
            cell.setProfileData(data: element)
            return cell
        }.disposed(by: disposeBag)
        
        
        unknownCollectionView.register(UINib(nibName: "MeetingProfileSelectCell", bundle: nil), forCellWithReuseIdentifier: "MeetingProfileSelectCell")
        
        meetingParticipantCountVM.unknownProfilesSubject.bind(to: unknownCollectionView.rx.items) { collectionView, row, element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingProfileSelectCell", for: IndexPath(row: row, section: 0)) as! MeetingProfileSelectCell
            
            cell.setProfileData(data: element)
            return cell
        }.disposed(by: disposeBag)
        
        attendanceCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let cell = owner.attendanceCollectionView.cellForItem(at: indexPath) as! MeetingProfileSelectCell
                
                owner.goUserProfileView(data:cell.profileData!)
                
            }).disposed(by: disposeBag)
        
        
    }
    
    func goUserProfileView(data:WorkspaceUser) {
        let userProfileVC = UserProfileViewController(nibName: "UserProfileViewController", bundle: nil)
        userProfileVC.modalPresentationStyle = .fullScreen
        present(userProfileVC, animated: true, completion: nil)
    }
    
    
    func setupCollectionViewLayout() {
        
        attendanceCollectionView.collectionViewLayout = UICollectionViewFlowLayout.profileCollectionViewLayout
        absenceCollectionView.collectionViewLayout = UICollectionViewFlowLayout.profileCollectionViewLayout
        unknownCollectionView.collectionViewLayout = UICollectionViewFlowLayout.profileCollectionViewLayout
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
