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
    
    @IBOutlet weak var agendaLabel: UILabel!
    @IBOutlet weak var agendaArrowButton: UIButton!
    @IBOutlet weak var agendaDocumentImage: UIImageView!
    @IBOutlet weak var documentCountLabel:UILabel!

    
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
        meetingVM.loadParticipantsCountInfo()
    }
    
    func configureUI() {
        if #available(iOS 13, *) {
            view.addSubview(UIView.statusBar)
        }
        setMeetingBasicInfo()
        setTotalParticipantCountInfo()
        setAgendaCountInfo()
    }
    
    private func setAgendaCountInfo() {
        meetingVM.agendaCountInfoSubject
            .withUnretained(self)
            .subscribe(onNext :{ owner, data in
                print(data,"✔️")
                if data.agendas == 0 {
                    owner.inactiviateAgendaTap()
                }else {
                    owner.activiateAgendaTap()
                }
                owner.documentCountLabel.text = "\(data.files)"
            }).disposed(by: disposeBag)
    }
    
    private func inactiviateAgendaTap() {
        agendaArrowButton.isEnabled = false
        
        agendaLabel.textColor = .darkGray
        agendaArrowButton.tintColor = .lightGray
        agendaDocumentImage.tintColor = .lightGray
        documentCountLabel.textColor = .lightGray
    }
    
    private func activiateAgendaTap() {
        agendaArrowButton.isEnabled = true
        
        agendaLabel.textColor = .black
        agendaArrowButton.tintColor = .darkGray
        agendaDocumentImage.tintColor = .grayBlue
        documentCountLabel.tintColor = .darkGray
    }
    
    private func setTotalParticipantCountInfo() {
        meetingVM.participantCountsByTeamSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                owner.setScrollViewContentViewHeight(dataCount: data.count)
                owner.setParticipantsCountLabel(data: data)
                
            }).disposed(by: disposeBag)
    }
    
    
    private func setParticipantsCountLabel(data:[ParticipantCountByTeam]) {
        var count = 0
        _ = data.map{count += ($0.attends + $0.absents + $0.unknowns)}
        
        participantsCountLabel.text = "\(count)명 예정"
    }
    
    func setScrollViewContentViewHeight(dataCount:Int) {
        let newHeight = CGFloat(dataCount*150 + 220)
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
    
    
    private func setMeetingBasicInfo() {
        
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
                    
                    owner.checkManager(data: data.admins)
                    
                    var managers:[String] = []
                    for manager in data.admins {
                        managers.append(manager.nickname)
                    }
                    
                    owner.managerLabel.text = managers.joined(separator: ", ")
                }
            }).disposed(by: disposeBag)
        
        
    }
    
    func checkManager(data: [Admin]) {
        guard let workspaceUserId = UserDefaults.standard.string(forKey: "workspaceUserId") else {return}
        
        if (data.filter{$0.workspaceUserId == Int(workspaceUserId)!}).count > 0 {
            meetingVM.deleteWorkspaceSubject
                .withUnretained(self)
                .subscribe(onNext: { owner, success in
                    if success {
                        owner.showDoneMeetingDeletePopUp()
                    }
                }).disposed(by: disposeBag)
        }else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        }
    }
    
    func showDoneMeetingDeletePopUp() {
        showOneButtonPopUpView(message: "해당 회의가 삭제되었습니다.", hasWorkspaceLabel: false, doneButtonTitle: "확인", doneCompletion: {
            
        })
    }
    
    
    
    @IBAction func goUserStatusCrationView(_ sender: Any) {
        let userStatusCreationVC = UserStatusCreationViewController(nibName: "UserStatusCreationViewController", bundle: nil)
        userStatusCreationVC.modalPresentationStyle = .fullScreen
        userStatusCreationVC.userStatusCreationVM = UserStatusCreationViewModel(meetingId: meetingVM.meetingId, meetingTitle: meetingTitle.text!)
        present(userStatusCreationVC, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goAgendaViewSegue" {
            let agendVC = segue.destination as! AgendaViewController
            
            agendVC.agendaVM = AgendaViewModel(meetingId: meetingVM.meetingId, agendaCount: meetingVM.agendaCount)
        }
    }
    
    @IBAction func back(_ sender:Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteMeeting(_ sender: Any) {
        showTwoButtonPopUpView(message: "해당 회의를 정말 삭제하시겠습니까?", subMessage: "", hasWorksapceLabel: false, leftButtonTitle: "닫기", rightButtonTitle: "삭제하기") {} rightCompletion: {
            self.meetingVM.deleteMeeting()
        }

    }
    
    
}

extension MeetingViewController:MeetingParticipantCountByTeamCellProtocol {
    
    func goMeetingParticipantCountByTeamView(data: ParticipantCountByTeam) {
        let meetingParticipantCountVC = self.storyboard?.instantiateViewController(withIdentifier: "MeetingParticipantCountViewController") as! MeetingParticipantCountViewController
        meetingParticipantCountVC.meetingParticipantCountVM = MeetingParticipantCountViewModel(data: data, meetingId: meetingVM.meetingId)
        
        navigationController?.pushViewController(meetingParticipantCountVC, animated: true)
    }
}
