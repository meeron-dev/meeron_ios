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
    var agendaCount = 0
    
    let meetingBasicInfoSubject = BehaviorSubject<MeetingBasicInfo?>(value:nil)
    let participantCountsByTeamSubject = BehaviorSubject<[ParticipantCountByTeam]>(value: [])
    let agendaCountInfoSubject = BehaviorSubject<AgendaCountInfo>(value: AgendaCountInfo(agendas: 0, checks: 0, files: 0))
    
    let deleteWorkspaceSubject = PublishSubject<Bool>()
    
    let meetingRepository = MeetingRepository()
    let participantRepository = ParticipantRepository()
    let disposeBag = DisposeBag()
    
    
    
    init(meetingId:Int) {
        self.meetingId = meetingId
        loadMeetingBasicInfo()
        loadParticipantsCountInfo()
        loadAgendaCountInfo()
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
                }
            }).disposed(by: disposeBag)
    }
    
    func loadAgendaCountInfo() {
        meetingRepository.loadMeetingAgendaCountInfo(meetingId: meetingId)
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                if let data = data {
                    owner.agendaCountInfoSubject.onNext(data)
                    owner.agendaCount = data.agendas
                }
            }).disposed(by: disposeBag)
    }
    
    func deleteMeeting() {
        guard let workspaceUserId = UserDefaults.standard.string(forKey: "workspaceUserId") else {return}
        meetingRepository.deleteMeeting(meetingId: meetingId, workspaceUserId: Int(workspaceUserId)!)
            .withUnretained(self)
            .subscribe(onNext: { owner, success in
                owner.deleteWorkspaceSubject.onNext(success)
            }).disposed(by: disposeBag)
    }
}
