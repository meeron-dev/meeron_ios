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
    @IBOutlet weak var agendaIssueDeleteLabel: UILabel!
    @IBOutlet weak var agendaIssueDeleteLabelWidth: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    
    var meetingAgendaCreationVM:MeetingAgendaCreationViewModel!
    var cellIndex:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGesture()
        agendaIssueTextField.rx.text.subscribe(onNext: {
            if $0 == "" {
                self.agendaIssueDeleteLabelWidth.constant = 0
            }else {
                self.agendaIssueDeleteLabelWidth.constant = 50
            }
        }).disposed(by: disposeBag)
    }
    
    func setCellInfo(vm:MeetingAgendaCreationViewModel, index:Int) {
        meetingAgendaCreationVM = vm
        cellIndex = index
    }
    
    private func addTapGesture() {
        let agendaIssueDeleteLabelTap = UIGestureRecognizer()
        agendaIssueDeleteLabelTap.addTarget(self, action: #selector(deleteCell))
        agendaIssueDeleteLabel.isUserInteractionEnabled = true
        agendaIssueDeleteLabel.addGestureRecognizer(agendaIssueDeleteLabelTap)
    }
    
    @objc func deleteCell() {
        print("삭제")
        if cellIndex == 0 {
            agendaIssueTextField.text = ""
        }else {
            meetingAgendaCreationVM.deleteIssue(index: cellIndex)
        }
    }
}
