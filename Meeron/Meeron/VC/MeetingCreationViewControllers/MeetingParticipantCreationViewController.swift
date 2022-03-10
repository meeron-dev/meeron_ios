//
//  MeetingParticipantCreationViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/03.
//

import Foundation
import UIKit
import RxSwift

class MeetingParticipantCreationViewController:UIViewController {
    
    @IBOutlet weak var prevButton:UIButton!
    @IBOutlet weak var nextButton:UIButton!
    
    @IBOutlet weak var meetingDate:UILabel!
    @IBOutlet weak var meetingTime:UILabel!
    @IBOutlet weak var meetingTitle:UILabel!
    
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var participantCountLabel:UILabel!
    @IBOutlet weak var nowTeamLabel: UILabel!
    
    @IBOutlet weak var searchButton:UIButton!
    
    @IBOutlet weak var teamTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var teamTableVIewOpenCloseButton: UIButton!
    
    @IBOutlet weak var participantProfileCollectionView: UICollectionView!
    
    
    let meetingParticipantCreationVM = MeetingParticipantCreationViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupTableView()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        
        meetingParticipantCreationVM.userProfilesSubejct
            .bind(to: participantProfileCollectionView.rx.items) { [weak self] collectionView, row, element in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingParticipantProfileCell", for: IndexPath(row: row, section: 0)) as! MeetingParticipantProfileCell
                cell.setData(data: element)
                guard let self = self else {
                    return cell
                }

                if self.meetingParticipantCreationVM.isSelectedUserProfile(data: element) {
                    cell.selectProfile()
                }else {
                    cell.deselectProfile()
                }
                return cell
            }.disposed(by: disposeBag)
        
        participantProfileCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let cell = owner.participantProfileCollectionView.cellForItem(at: indexPath) as! MeetingParticipantProfileCell
                owner.meetingParticipantCreationVM.selectUserProfile(data: cell.profileData!)
            }).disposed(by: disposeBag)
        
        setupCollectionViewLayout()
        
    }
    private func setupCollectionViewLayout() {
        let participantProfileCollectionViewLayout = UICollectionViewFlowLayout()
        participantProfileCollectionViewLayout.itemSize = CGSize(width: 70, height: 100)
        participantProfileCollectionViewLayout.minimumInteritemSpacing = 10
        participantProfileCollectionViewLayout.minimumLineSpacing = 20
        
        participantProfileCollectionView.collectionViewLayout = participantProfileCollectionViewLayout
    }
    
    private func setupTableView() {
        
        meetingParticipantCreationVM.teamsSubject.bind(to: teamTableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingParticipantTeamCell", for: IndexPath(row: row, section: 0)) as! MeetingParticipantTeamCell
            cell.setData(data: element)
            return cell
        }.disposed(by: disposeBag)
        
        teamTableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, index in
                let cell = owner.teamTableView.cellForRow(at: index) as! MeetingParticipantTeamCell
                owner.meetingParticipantCreationVM.nowTeamSubject.onNext(cell.teamData)
            }).disposed(by: disposeBag)
        
    }
    
    private func configureUI() {
        self.navigationItem.titleView = UILabel.meetingCreationNavigationItemTitleLabel
        
        prevButton.addShadow()
        nextButton.addShadow()
        
        meetingParticipantCreationVM.selectedUserProfilesCountSubject
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, count in
                owner.participantCountLabel.text = "\(count)명 선택됨"
            }).disposed(by: disposeBag)
        
        meetingParticipantCreationVM.nowTeamSubject
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, team in
                owner.nowTeamLabel.text = team?.teamName
            }).disposed(by: disposeBag)
    }
    
    @IBAction func tapTeamTableViewButton(_ sender: Any) {
        if teamTableViewHeight.constant == 0 {
            openTeamTalbeView()
        }else {
            closeTeamTableView()
        }
    }
    
    
    func closeTeamTableView() {
        teamTableViewHeight.constant = 0
        teamTableVIewOpenCloseButton.setImage(UIImage(named: "expand_more"), for: .normal)
    }
    
    func openTeamTalbeView() {
        teamTableVIewOpenCloseButton.setImage(UIImage(named: "expand_more-1"), for: .normal)
        if meetingParticipantCreationVM.teams.count > 5 {
            teamTableViewHeight.constant = 240
        }else {
            teamTableViewHeight.constant = CGFloat(meetingParticipantCreationVM.teams.count*60)
        }
        
    }
    
    func addShadowTeamTableView() {
        teamTableView.layer.shadowColor = UIColor.black.cgColor
        teamTableView.layer.shadowOpacity = 0.3
        teamTableView.layer.shadowOffset = CGSize(width: 0, height: 5)
        teamTableView.layer.shadowRadius = 5
        
    }
    
    func deleteShadowTeamTableView() {
        teamTableView.layer.shadowColor = UIColor.black.cgColor
        teamTableView.layer.shadowOpacity = 0
        teamTableView.layer.shadowOffset = CGSize(width: 0, height: 0)
        teamTableView.layer.shadowRadius = 0
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func close(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchParticipant(_ sender: Any) {
        let profileSelectVC = self.storyboard?.instantiateViewController(withIdentifier: "MeetingProfileSelectViewController") as! MeetingProfileSelectViewController
        
        profileSelectVC.delegate = self
        
        profileSelectVC.modalPresentationStyle = .custom
        profileSelectVC.transitioningDelegate = self
        present(profileSelectVC, animated: true, completion: nil)
        profileSelectVC.profileSelectTitleLabel.text = "회의 참가자 선택하기"
    }
    
}

extension MeetingParticipantCreationViewController: MeetingProfileSelectViewControllerDelegate {
    
    func passSelectedProfiles(selectedProfiles: [WorkspaceUser]) {
        meetingParticipantCreationVM.addSelectedUserProfiles(data: selectedProfiles)
    }
    
    
}

extension MeetingParticipantCreationViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SelectItemModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
   
