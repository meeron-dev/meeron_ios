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
    let participantCountsByTeamSubject = BehaviorSubject<[ParticipantCountByTeam]>(value: [])
    let participantCountTotalSubject = BehaviorSubject<Int>(value: 0)
    
    let meetingRepository = MeetingRepository()
    let participantRepository = ParticipantRepository()
    let disposeBag = DisposeBag()
    
    init(meetingId:Int) {
        self.meetingId = meetingId
        loadMeetingBasicInfo()
        loadParticipantsCountInfo()
    }
    
    func loadMeetingBasicInfo() {
        meetingRepository.loadMeetingBasicInfo(meetingId: meetingId)
            .withUnretained(self)
            .subscribe(onNext: { owner, meetingBasicInfo in
                owner.meetingBasicInfoSubject.onNext(meetingBasicInfo)
            }).disposed(by: disposeBag)
    }
    
    func loadParticipantsCountInfo() {
        participantRepository.loadParticipantsCountByTeam(meetingId: meetingId)
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                if let data = data {
                    owner.participantCountsByTeamSubject.onNext(data.attendees)
                    var participantTotalCount = 0
                    for i in 0..<data.attendees.count {
                        participantTotalCount += data.attendees[i].attends
                    }
                    owner.participantCountTotalSubject.onNext(participantTotalCount)
                }
            }).disposed(by: disposeBag)
    }
}
