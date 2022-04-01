//
//  MeetingViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/01.
//

import Foundation
import RxSwift

class MeetingViewModel {
    
    let meetingId:Int
    
    let meetingBasicInfoSubject = BehaviorSubject<MeetingBasicInfo?>(value:nil)
    
    let meetingRepository = MeetingRepository()
    let disposeBag = DisposeBag()
    
    init(meetingId:Int) {
        self.meetingId = meetingId
        loadMeetingBasicInfo()
    }
    
    func loadMeetingBasicInfo() {
        meetingRepository.loadMeetingBasicInfo(meetingId: meetingId)
            .withUnretained(self)
            .subscribe(onNext: { owner, meetingBasicInfo in
                owner.meetingBasicInfoSubject.onNext(meetingBasicInfo)
            }).disposed(by: disposeBag)
        
        
    }
}
