//
//  ManagerSelectViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/03.
//

import Foundation
import UIKit
import RxSwift

protocol MeetingProfileSelectViewControllerDelegate: AnyObject {
    func passSelectedProfiles(selectedProfiles:[WorkspaceUser])
}

class MeetingProfileSelectViewController:UIViewController {
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    @IBOutlet weak var profileSelectTitleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    let meetingProfileSelectVM = MeetingProfileSelectViewModel()
    
    var delegate:MeetingProfileSelectViewControllerDelegate?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        let tapper = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tapper)
        
        
    }
    
    private func configureUI() {
        closeButton.addShadow()
        doneButton.addShadow()
        
        meetingProfileSelectVM.selectedUserProfilesSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                if $0.count > 0 {
                    self.doneButton.isEnabled = true
                }else {
                    self.doneButton.isEnabled = false
                }
            }).disposed(by: disposeBag)
        
        setupCollectionView()
        setupCollectionViewLayout()
        setupTextField()
        
    }
    
    private func setupTextField() {
        searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: {
                self.meetingProfileSelectVM.loadUserInWorkspace(searchNickname: $0)
            }).disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        profileCollectionView.register(UINib(nibName: "MeetingParticipantProfileCell", bundle: nil), forCellWithReuseIdentifier: "MeetingParticipantProfileCell")
        
        meetingProfileSelectVM.userProfilesSubject.bind(to: profileCollectionView.rx.items) { collectionView, row, element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingParticipantProfileCell", for: IndexPath(row: row, section: 0)) as! MeetingParticipantProfileCell
            cell.setData(data: element, vm: self.meetingProfileSelectVM)
            return cell
        }.disposed(by: disposeBag)
    }
    
    private func setupCollectionViewLayout() {
        let profileCollectionViewLayout = UICollectionViewFlowLayout()
        profileCollectionViewLayout.itemSize = CGSize(width: 70, height: 100)
        profileCollectionViewLayout.minimumInteritemSpacing = 10
        profileCollectionViewLayout.minimumLineSpacing = 20
        
        profileCollectionView.collectionViewLayout = profileCollectionViewLayout
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func done(_ sender: Any) {
        delegate?.passSelectedProfiles(selectedProfiles: meetingProfileSelectVM.selectedUserProfiles)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

