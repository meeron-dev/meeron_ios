//
//  MeetingViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/31.
//

import Foundation
import UIKit
import RxSwift

class MeetingViewController:UIViewController {
    
    @IBOutlet weak var workspaceLabel:UILabel!
    @IBOutlet weak var meetingTitle:UILabel!
    @IBOutlet weak var meetingTeamLabel:UILabel!
    @IBOutlet weak var managerLabel:UILabel!
    @IBOutlet weak var meetingPurposeLabel:UILabel!
    @IBOutlet weak var meetingDateLabel:UILabel!
    @IBOutlet weak var meetingTimeLabel:UILabel!
    
    @IBOutlet weak var agendaCheckCountLabel:UILabel!
    @IBOutlet weak var documentCountLabel:UILabel!
    @IBOutlet weak var meetingResultCheckCountLabel:UILabel!
    
    @IBOutlet weak var participantsCountLabel:UILabel!
    @IBOutlet weak var participantCountByTeamTableView: UITableView!
    
    @IBOutlet weak var scrollViewContentViewHeight:NSLayoutConstraint!
    
    var meetingVM:MeetingViewModel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = .statusBarGray
    }
    
    func configureUI() {
        if #available(iOS 13, *) {
            view.addSubview(UIView.statusBar)
        }
        setBasicInfo()
        
        meetingVM.participantCountsByTeamSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                owner.setScrollViewContentViewHeight(dataCount: data.count)
                owner.setParticipantsCountLabel(data: data)
                
            }).disposed(by: disposeBag)
        
        
    }
    
    func setParticipantsCountLabel(data:[ParticipantCountByTeam]) {
        var count = 0
        _ = data.map{count += ($0.attends + $0.absents + $0.unknowns)}
        
        participantsCountLabel.text = "\(count)명 예정"
    }
    
    func setScrollViewContentViewHeight(dataCount:Int) {
        let newHeight = CGFloat(dataCount*150 + 325)
        let oldHeight = view.safeAreaLayoutGuide.layoutFrame.height - 190
        
        scrollViewContentViewHeight.constant = max(newHeight,oldHeight)
    }
     
    private func setupTableView() {
        
        
        meetingVM.participantCountsByTeamSubject
            .bind(to: participantCountByTeamTableView.rx.items) { tableView, row, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingParticipantCountByTeamCell", for: IndexPath(row: row, section: 0)) as! MeetingParticipantCountByTeamCell
                
                cell.setData(data: element)
                cell.delegate = self
                return cell
                
            }.disposed(by: disposeBag)
    }
    
    
    private func setBasicInfo() {
        
        workspaceLabel.text = UserDefaults.standard.string(forKey: "workspaceName")
        meetingVM.meetingBasicInfoSubject
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, data in
                if let data = data {
                    owner.meetingTitle.text = data.meetingName
                    owner.meetingDateLabel.text = data.startTime+"~"+data.endTime
                    owner.meetingTeamLabel.text = data.operationTeamName
                    owner.meetingPurposeLabel.text = data.meetingPurpose
                    var managers:[String] = []
                    for manager in data.admins {
                        managers.append(manager.nickname)
                    }
                    
                    owner.managerLabel.text = managers.joined(separator: ", ")
                }
            }).disposed(by: disposeBag)
        
        
    }
    
    @IBAction func goUserStatusCrationView(_ sender: Any) {
        let userStatusCreationVC = UserStatusCreationViewController(nibName: "UserStatusCreationViewController", bundle: nil)
        userStatusCreationVC.modalPresentationStyle = .fullScreen
        present(userStatusCreationVC, animated: true, completion: nil)
    }
    
    
    @IBAction func back(_ sender:Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}

extension MeetingViewController:MeetingParticipantCountByTeamCellProtocol {
    
    func goMeetingParticipantCountByTeamView(data: ParticipantCountByTeam) {
        let meetingParticipantCountVC = self.storyboard?.instantiateViewController(withIdentifier: "MeetingParticipantCountViewController") as! MeetingParticipantCountViewController
        meetingParticipantCountVC.meetingParticipantCountVM = MeetingParticipantCountViewModel(data: data, meetingId: meetingVM.meetingId)
        
        navigationController?.pushViewController(meetingParticipantCountVC, animated: true)
    }
}
