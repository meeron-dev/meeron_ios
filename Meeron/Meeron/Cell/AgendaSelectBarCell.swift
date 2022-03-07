//
//  AgendaSelectBarCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/04.
//

import Foundation
import UIKit
import RxSwift

class AgendaSelectBarCell:UICollectionViewCell {
    
    @IBOutlet weak var agendaNumberView: UIView!
    @IBOutlet weak var agendaNumber: UILabel!
    
    var meetingAgendaCreationVM:MeetingAgendaCreationViewModel!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(selectNumber))
        contentView.addGestureRecognizer(tapGesture)
        
    }
    func setVM(vm:MeetingAgendaCreationViewModel) {
        meetingAgendaCreationVM = vm
        meetingAgendaCreationVM.nowAgendaIndexSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
            if String($0+1) == self.agendaNumber.text  {
                self.agendaNumber.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
                self.agendaNumber.textColor = .mrBlue
            }else {
                self.agendaNumber.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 30)
                self.agendaNumber.textColor = UIColor(red: 129/255, green: 129/255, blue: 129/255, alpha: 1)
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func selectNumber() {
        meetingAgendaCreationVM.nowAgendaIndexSubject.onNext(Int(agendaNumber.text!)!-1)
    }
}
