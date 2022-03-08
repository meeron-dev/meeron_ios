//
//  TimeSelectViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/03.
//

import Foundation
import UIKit
import RxSwift

protocol MeetingTeamSelectViewControllerDelegate {
    func passSelectedTeam(data:Team?)
}

class MeetingTeamSelectViewController:UIViewController {
    
    @IBOutlet weak var teamTableView: UITableView!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    let meetingTeamSelectVM = MeetingTeamSelectViewModel()
    
    var delegate:MeetingTeamSelectViewControllerDelegate?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meetingTeamSelectVM.loadTeamInWorkspace()
        configureUI()
    }
    
    private func configureUI() {
        configureButton()
        configureTableView()
    }
    
    private func configureButton() {
        doneButton.addShadow()
        closeButton.addShadow()
        
        meetingTeamSelectVM.selectedTeamSubject
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, selectedTeam in
                if selectedTeam == nil {
                    owner.doneButton.isEnabled = false
                }else {
                    owner.doneButton.isEnabled = true
                }
            }).disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        
        meetingTeamSelectVM.teamsSubject.bind(to: teamTableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingTeamSelectCell", for: IndexPath(row: row, section: 0)) as! MeetingTeamSelectCell
            cell.setTeamData(data: element)
            return cell
        }.disposed(by: disposeBag)
        
        
        teamTableView.allowsMultipleSelection = false
        
        teamTableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let cell = owner.teamTableView.cellForRow(at: indexPath) as! MeetingTeamSelectCell
                if cell.isSelected() {
                    owner.meetingTeamSelectVM.selectedTeamSubject.onNext(cell.teamData)
                }else {
                    owner.meetingTeamSelectVM.selectedTeamSubject.onNext(nil)
                }
            }).disposed(by: disposeBag)
        
        teamTableView.rx.itemDeselected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let cell = owner.teamTableView.cellForRow(at: indexPath) as! MeetingTeamSelectCell
                cell.isDeseleted()
            }).disposed(by: disposeBag)
        
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        delegate?.passSelectedTeam(data: meetingTeamSelectVM.selectedTeam)
        self.dismiss(animated: true, completion: nil)
    }
}
