//
//  AgendaIssueCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/03.
//

import Foundation
import UIKit
import RxSwift

class AgendaIssueCell:UITableViewCell {
    @IBOutlet weak var agendaIssueTextField: UITextField!
    
    @IBOutlet weak var agendaIssueDeleteButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var agendaIssueDeleteButton: UIButton!
    let disposeBag = DisposeBag()
    
    var meetingAgendaCreationVM:MeetingAgendaCreationViewModel?
    var cellIndex:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        agendaIssueTextField.rx.text.subscribe(onNext: {
            if $0 == "" {
                self.agendaIssueDeleteButtonWidth.constant = 0
            }else {
                self.agendaIssueDeleteButtonWidth.constant = 60
            }
            self.meetingAgendaCreationVM?.nowIssueIndex = self.cellIndex ?? 0
            self.saveIssue()
        }).disposed(by: disposeBag)
    }
    
    @IBAction func deleteCell(_ sender: Any) {
        if cellIndex == 0 {
            agendaIssueTextField.text = ""
            saveIssue()
        }else {
            print(meetingAgendaCreationVM?.getAgenda().issue.count, cellIndex)
            meetingAgendaCreationVM?.deleteIssue(index: cellIndex ?? 0)
        }
    }
    func setCellInfo(vm:MeetingAgendaCreationViewModel, index:Int) {
        meetingAgendaCreationVM = vm
        cellIndex = index
        if agendaIssueTextField.text == "" {
            agendaIssueDeleteButtonWidth.constant = 0
        }else {
            agendaIssueDeleteButtonWidth.constant = 60
        }
    }
    func saveIssue() {
        meetingAgendaCreationVM?.saveAgendaIssue(issue: self.agendaIssueTextField.text!, index: cellIndex ?? 0)
    }
}
