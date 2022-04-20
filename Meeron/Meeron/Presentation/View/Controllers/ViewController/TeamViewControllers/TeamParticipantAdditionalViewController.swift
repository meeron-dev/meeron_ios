//
//  TeamParticipantAdditionalViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/27.
//

import Foundation
import UIKit
import RxSwift

class TeamParticipantAdditionalViewController:UIViewController {
    
    @IBOutlet weak var profileCollectionView:UICollectionView!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var selectedProfileCountLabel:UILabel!
    
    @IBOutlet weak var noParticipantsLabelWidth: NSLayoutConstraint!
    
    var teamParticipantAdditionalVM: TeamParticipantAdditionalViewModel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        configureUI()
    }
    
    private func configureUI() {
        doneButton.addShadow()
        teamParticipantAdditionalVM.noParticipantLabelWidthSubejct
            .withUnretained(self)
            .subscribe(onNext: { owner, constant in
                owner.noParticipantsLabelWidth.constant = constant
                
            }).disposed(by: disposeBag)
        
        teamParticipantAdditionalVM.selectedParticipantsCountSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, count in
                owner.selectedProfileCountLabel.text = "\(count)명 선택됨"
                
                if count == 0 {
                    owner.doneButton.isEnabled = false
                }else {
                    owner.doneButton.isEnabled = true
                }
            }).disposed(by: disposeBag)
        
        doneButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.addParticipant()
            }).disposed(by: disposeBag)
        
        teamParticipantAdditionalVM.successParticipantAddtitionalSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, success in
                if success {
                    owner.closeView()
                }
                
            }).disposed(by: disposeBag)
    }
    
    func addParticipant() {
        teamParticipantAdditionalVM.addParticipant()
    }
    
    func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    private func setupCollectionView() {
        setupCollectionViewLayout()
        profileCollectionView.register(UINib(nibName: "MeetingProfileSelectCell", bundle: nil), forCellWithReuseIdentifier: "MeetingProfileSelectCell")
        
        
        teamParticipantAdditionalVM.participantsSubject.bind(to: profileCollectionView.rx.items) { [weak self] collectionView, row, element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingProfileSelectCell", for: IndexPath(row: row, section: 0)) as! MeetingProfileSelectCell
            
            cell.setProfileData(data: element)
            
            guard let self = self else {
                return cell
            }

            if self.teamParticipantAdditionalVM.isSelectedProfile(data: element) {
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
                owner.teamParticipantAdditionalVM.selectProfile(data: cell.profileData!)
                
            }).disposed(by: disposeBag)
    }
    
    
    func setupCollectionViewLayout() {
        profileCollectionView.collectionViewLayout = UICollectionViewFlowLayout.profileCollectionViewLayout
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
