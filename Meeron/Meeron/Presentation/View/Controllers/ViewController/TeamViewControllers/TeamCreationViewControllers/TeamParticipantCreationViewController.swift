//
//  TeamParticipantViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/30.
//

import Foundation
import UIKit
import RxSwift

class TeamParticipantCreationViewController:UIViewController {
    
    @IBOutlet weak var workspaceNameLabel: UILabel!
    @IBOutlet weak var selectedParticipantCountLabel: UILabel!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var noParticipantLabelWidth: NSLayoutConstraint!
    
    
    var teamCreationVM: TeamCreationViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        setupCollectionViewLayout()
        
        profileCollectionView.register(UINib(nibName: "MeetingProfileSelectCell", bundle: nil), forCellWithReuseIdentifier: "MeetingProfileSelectCell")
        
        
        teamCreationVM.participantsSubject.bind(to: profileCollectionView.rx.items) { [weak self] collectionView, row, element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingProfileSelectCell", for: IndexPath(row: row, section: 0)) as! MeetingProfileSelectCell
            
            cell.setProfileData(data: element)
            
            guard let self = self else {
                return cell
            }

            if self.teamCreationVM.isSelectedProfile(data: element) {
                cell.selectProfile()
            }else {
                cell.deselectProfile()
            }
            
            return cell
        }.disposed(by: disposeBag)
        
        profileCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let cell = owner.profileCollectionView.cellForItem(at: indexPath) as! MeetingProfileSelectCell
                owner.teamCreationVM.selectProfile(data: cell.profileData!)
                
            }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prevButton.addShadow()
        nextButton.addShadow()
        workspaceNameLabel.text = UserDefaults.standard.string(forKey: "workspaceName")
        
        teamCreationVM.noParticipantLabelWidthSubejct
            .withUnretained(self)
            .subscribe(onNext: { owner, constant in
                owner.noParticipantLabelWidth.constant = constant
                
            }).disposed(by: disposeBag)
        
        teamCreationVM.selectedParticipantsCountSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, count in
                owner.selectedParticipantCountLabel.text = "\(count)명 선택됨"
            }).disposed(by: disposeBag)
        
        teamCreationVM.successTeamCreation
            .withUnretained(self)
            .subscribe(onNext: { owner, success in
                if success {
                    owner.goTeamCreationResultView()
                }
                
            }).disposed(by: disposeBag)
        
    
    }
    
    @IBAction func next(_ sender: Any) {
        teamCreationVM.createTeam()
    }
    
    func goTeamCreationResultView() {
        let teamCreationResultVC = self.storyboard?.instantiateViewController(withIdentifier: "TeamCreationResultViewController") as! TeamCreationResultViewController
        
        self.navigationController?.pushViewController(teamCreationResultVC, animated: true)
        
        teamCreationResultVC.setData(teamName:teamCreationVM.teamName, participantCount:teamCreationVM.selectedParticipants.count)
        
    }
    
    
    func setupCollectionViewLayout(){
        let participantProfileCollectionViewLayout = UICollectionViewFlowLayout()
        participantProfileCollectionViewLayout.itemSize = CGSize(width: 70, height: 100)
        participantProfileCollectionViewLayout.minimumInteritemSpacing = 10
        participantProfileCollectionViewLayout.minimumLineSpacing = 20
        
        profileCollectionView.collectionViewLayout = participantProfileCollectionViewLayout
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
