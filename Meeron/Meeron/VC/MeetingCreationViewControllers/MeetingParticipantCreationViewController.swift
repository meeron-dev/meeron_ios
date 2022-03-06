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
    @IBOutlet weak var participantCountDate:UILabel!
    
    @IBOutlet weak var searchButton:UIButton!
    
    @IBOutlet weak var teamTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var teamTableVIewOpenCloseButton: UIButton!
    
    @IBOutlet weak var participantProfileCollectionView: UICollectionView!
    
    
    let meetingParticipantCreationVM = MeetingParticipantCreationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupTableView()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        participantProfileCollectionView.dataSource = self
        participantProfileCollectionView.delegate = self
        participantProfileCollectionView.register(UINib(nibName: "MeetingParticipantProfileCell", bundle: nil), forCellWithReuseIdentifier: "MeetingParticipantProfileCell")
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
        teamTableView.delegate = self
        teamTableView.dataSource = self
    }
    
    private func configureUI() {
        self.navigationItem.titleView = UILabel.meetingCreationNavigationItemTitleLabel
        
        prevButton.addShadow()
        nextButton.addShadow()
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
        let profileSelectVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileSelectViewController") as! ProfileSelectViewController
        present(profileSelectVC, animated: true, completion: nil)
        profileSelectVC.profileSelectTitleLabel.text = "회의 참가자 선택하기"
    }
    
}

extension MeetingParticipantCreationViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SelectItemModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
                                                    
extension MeetingParticipantCreationViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingParticipantCreationVM.teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingParticipantTeamCell") as! MeetingParticipantTeamCell
        cell.teamLabel.text = meetingParticipantCreationVM.teams[indexPath.row]
        return cell
    }
}

extension MeetingParticipantCreationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingParticipantProfileCell", for: indexPath) as! MeetingParticipantProfileCell
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }

}
