//
//  TeamViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/26.
//

import Foundation
import UIKit
import RxSwift

class TeamViewController:UIViewController {
    
    @IBOutlet weak var teamCollectionView:UICollectionView!
    @IBOutlet weak var teamParticipantCollectionView:UICollectionView!
    @IBOutlet weak var calendarImageView:UIImageView!
    @IBOutlet weak var manageImageView:UIImageView!
    
    @IBOutlet weak var teamNameLabel:UILabel!
    
    @IBOutlet weak var participantCountLabelHeight:NSLayoutConstraint!
    
    
    let teamVM = TeamViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        configureUI()
        addTapper()
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        teamVM.loadTeam()
    }
    
    private func addTapper() {
        calendarImageView.isUserInteractionEnabled = true
        let calendarTapper = UITapGestureRecognizer()
        calendarTapper.addTarget(self, action: #selector(goCalendarView))
        calendarImageView.addGestureRecognizer(calendarTapper)
        
        manageImageView.isUserInteractionEnabled = true
        let teamManageTapper = UITapGestureRecognizer()
        teamManageTapper.addTarget(self, action: #selector(goTeamManagementView))
        manageImageView.addGestureRecognizer(teamManageTapper)
    }
    
    @objc func goTeamManagementView() {
        guard let nowTeam = teamVM.nowTeam else {return}
        let teamManagementVC = self.storyboard?.instantiateViewController(withIdentifier: "TeamManagementViewController") as! TeamManagementViewController
        teamManagementVC.teamManagementVM = TeamManagementViewModel(participants: teamVM.particiapnt, nowTeam: nowTeam)
        teamManagementVC.modalPresentationStyle = .fullScreen
        present(teamManagementVC, animated: true, completion: nil)
    }
    
    @objc func goCalendarView() {
        let calendarVC = CalendarViewController(nibName: "CalendarViewController", bundle: nil)
        calendarVC.calendarVM = CalendarViewModel(type: .workspace)
        calendarVC.calendarType = .workspace
        
        calendarVC.modalPresentationStyle = .fullScreen
        present(calendarVC, animated: true, completion: nil)
        calendarVC.workspaceNameLabel.text = teamNameLabel.text
    }
    
    private func configureUI() {
        setStausBarColor()
        teamVM.nowTeamSubject
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, nowTeam in
                if nowTeam == nil {
                    owner.teamNameLabel.text = "NONE"
                }else {
                    owner.teamNameLabel.text = nowTeam!.teamName
                }
                print("???",nowTeam?.teamName)
            }).disposed(by: disposeBag)
        
        
        teamVM.participantCountLabelHeightSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, height in
                owner.participantCountLabelHeight.constant = height
            }).disposed(by: disposeBag)
    }
    
    private func setStausBarColor() {
        if #available(iOS 13, *) {
            view.addSubview(UIView.statusBar)
        }

    }
    
    private func setupCollectionView() {
        setupCollectionViewLayout()
        
        teamVM.teamsSubject.bind(to: teamCollectionView.rx.items) { collectionView, row, element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: IndexPath(row: row, section: 0)) as! TeamCell
            if row > 0 && element == nil {
                cell.setData(data: nil, index: 6)
            }else {
                cell.setData(data: element, index: row)
            }
            
            return cell
        }.disposed(by: disposeBag)
        
        teamParticipantCollectionView.register(UINib(nibName: "MeetingProfileSelectCell", bundle: nil), forCellWithReuseIdentifier: "MeetingProfileSelectCell")
        
        teamVM.teamParticipantSubject.bind(to: teamParticipantCollectionView.rx.items) { collectionView, row, element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingProfileSelectCell", for: IndexPath(row: row, section: 0)) as! MeetingProfileSelectCell
            
            cell.setProfileData(data: element)
            return cell
        }.disposed(by: disposeBag)
        
        teamCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let cell = owner.teamCollectionView.cellForItem(at: indexPath) as! TeamCell
                if let data = cell.teamData {
                    owner.teamVM.nowTeamSubject.onNext(data)
                }else {
                    if cell.index == 0 {
                        owner.goCreationTeamView()
                    }else if cell.index == 6 {
                        owner.teamVM.nowTeamSubject.onNext(nil) //NONE
                    }
                }
                print(cell.teamData, cell.index)
                
            }).disposed(by: disposeBag)
    }
    
    func goCreationTeamView() {
        let teamCreationNaviC = self.storyboard?.instantiateViewController(withIdentifier: "TeamCreationNavigationController")
        teamCreationNaviC?.modalPresentationStyle = .fullScreen
        present(teamCreationNaviC!, animated: true, completion: nil)
        
    }
    
    func setupCollectionViewLayout(){
        let participantProfileCollectionViewLayout = UICollectionViewFlowLayout()
        participantProfileCollectionViewLayout.itemSize = CGSize(width: 70, height: 100)
        participantProfileCollectionViewLayout.minimumInteritemSpacing = 10
        participantProfileCollectionViewLayout.minimumLineSpacing = 20
        
        teamParticipantCollectionView.collectionViewLayout = participantProfileCollectionViewLayout
        
        let teamCollectionViewLayout = UICollectionViewFlowLayout()
        teamCollectionViewLayout.scrollDirection = .horizontal
        teamCollectionViewLayout.itemSize = CGSize(width: 50, height: 50)
        teamCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        teamCollectionViewLayout.minimumInteritemSpacing = 20
        teamCollectionViewLayout.minimumLineSpacing = 0
        
        teamCollectionView.collectionViewLayout = teamCollectionViewLayout
    }
    
    
}
