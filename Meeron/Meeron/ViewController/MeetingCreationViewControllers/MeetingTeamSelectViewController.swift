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
    
    let meetingTeamSelectVM = MeetingTeamSelectViewModel()
    
    var delegate:MeetingTeamSelectViewControllerDelegate?
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    var viewVelocity = CGPoint(x: 0, y: 0)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meetingTeamSelectVM.loadTeamInWorkspace()
        configureUI()
        addGestureRecognizer()
    }
    
    private func configureUI() {
        configureButton()
        configureTableView()
    }
    
    func addGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissWithPanGesture))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func dismissWithPanGesture(_ sender:UIPanGestureRecognizer) {
        viewTranslation = sender.translation(in: view)
        viewVelocity = sender.velocity(in: view)
        
        switch sender.state {
        case .changed:
            if abs(viewVelocity.y) > abs(viewVelocity.x) {
                if viewVelocity.y > 0 {
                    UIView.animate(withDuration: 0.1) {
                        self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                    }
                }
            }
        case .ended:
            if viewTranslation.y < 400 {
                UIView.animate(withDuration: 0.1) {
                    self.view.transform = .identity
                }
            } else {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }

    }
    
    private func configureButton() {
        doneButton.addShadow()
        
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
                if cell.isSelectedTeam() {
                    owner.meetingTeamSelectVM.selectedTeamSubject.onNext(cell.teamData)
                }else {
                    owner.meetingTeamSelectVM.selectedTeamSubject.onNext(nil)
                }
            }).disposed(by: disposeBag)
        
        teamTableView.rx.itemDeselected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let cell = owner.teamTableView.cellForRow(at: indexPath) as! MeetingTeamSelectCell
                cell.isDeseletedTeam()
            }).disposed(by: disposeBag)
        
    }
    
    
    @IBAction func done(_ sender: Any) {
        delegate?.passSelectedTeam(data: meetingTeamSelectVM.selectedTeam)
        self.dismiss(animated: true, completion: nil)
    }
}
