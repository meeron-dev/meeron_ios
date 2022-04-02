//
//  UserStatusCreationViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/03.
//

import Foundation
import RxSwift


class UserStatusCreationViewModel {
    
    let paricipantRepository = ParticipantRepository()
    
    let meetingId:Int
    let meetingTitle:String
    let disposeBag = DisposeBag()
    
    init(meetingId:Int, meetingTitle:String) {
        self.meetingId = meetingId
        self.meetingTitle = meetingTitle
    }
    
    func patchUserStatus(status: ParicipantStatusType) {
        paricipantRepository.patchParicipantStatus(meetingId: meetingId, status: status)
            .subscribe(onNext: {
                print($0, "🥲")
            }).disposed(by: disposeBag)
    }
}
