//
//  TeamManagementViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/26.
//

import Foundation
import UIKit
import RxSwift

class TeamManagementViewController:UIViewController {
    
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    var teamManagementVM: TeamManagementViewModel!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupButton()
        setupCollectionView()
        setupTextField()
        
        
    }
    
    private func setupTextField() {
        teamNameTextField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                owner.teamManagementVM.saveTeamName(teamName: text)
            }).disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        
        profileCollectionView.register(UINib(nibName: "MeetingProfileDeleteCell", bundle: nil), forCellWithReuseIdentifier: "MeetingProfileDeleteCell")
        
        teamManagementVM.participantsSubject.bind(to: profileCollectionView.rx.items) { [weak self] collectionView, row, element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingProfileDeleteCell", for: IndexPath(row: row, section: 0)) as! MeetingProfileDeleteCell
            
            cell.setData(data: element) { workspaceUser in
                self?.deleteProfile(data:workspaceUser)
            }
            return cell
            
        }.disposed(by: disposeBag)
        setupCollectionViewLayout()
    }
    
    func setupCollectionViewLayout() {
        let participantProfileCollectionViewLayout = UICollectionViewFlowLayout()
        participantProfileCollectionViewLayout.itemSize = CGSize(width: 75, height: 105)
        participantProfileCollectionViewLayout.minimumInteritemSpacing = 10
        participantProfileCollectionViewLayout.minimumLineSpacing = 20
        
        profileCollectionView.collectionViewLayout = participantProfileCollectionViewLayout
    }
    
    private func deleteProfile(data: WorkspaceUser) {
        teamManagementVM.deleteProfile(data: data)
    }
    
    private func setupButton(){
        let doneButton = UIButton()
        view.addSubview(doneButton)
        
        doneButton.setupBottomButton(type: .long, state: .enableGray, title: "팀 삭제하기", view: view)
        
        doneButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.showDeleteTeamPopUp()
            }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        addDismissKeyboardTapper()
        
        teamNameTextField.text = teamManagementVM.nowTeam.teamName
        
        teamManagementVM.successTeamDeleteSubejct
            .withUnretained(self)
            .subscribe(onNext: { owner, success in
                if success  {
                    owner.showSuccessDeleteTeamPopUp()
                }
            }).disposed(by: disposeBag)
    }
    
    func showSuccessDeleteTeamPopUp() {
        showOneButtonPopUpView(message: "해당 팀이 삭제되었습니다.", doneButtonTitle: "확인", doneCompletion: nil)
    }
    
    func showDeleteTeamPopUp(){
        showTwoButtonPopUpView(message: "해당 팀을 정말 삭제하시겠습니까?", leftButtonTitle: "닫기", rightButtonTitle: "삭제하기") {
            self.deleteTeam()
        }
    }
    
    func deleteTeam() {
        teamManagementVM.deleteTeam()
    }
    
    @IBAction func goParticipantAdditionView(_ sender: Any) {
        let teamParticipantAdditionalVC = self.storyboard?.instantiateViewController(withIdentifier: "TeamParticipantAdditionalViewController") as! TeamParticipantAdditionalViewController
        teamParticipantAdditionalVC.modalPresentationStyle = .fullScreen
        present(teamParticipantAdditionalVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        //팀 변경 사항 반영 후 dismiss
        dismiss(animated: true, completion: nil)
    }
    
}
