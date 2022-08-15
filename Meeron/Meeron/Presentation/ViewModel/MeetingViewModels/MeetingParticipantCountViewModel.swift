//
//  MeetingParticipantCountByTeamViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/02.
//

import Foundation
import RxSwift

class MeetingParticipantCountViewModel {
    
    let attendanceProfilesSubject =  BehaviorSubject<[WorkspaceUser]>(value:[])
    let absenceProfilesSubject =  BehaviorSubject<[WorkspaceUser]>(value:[])
    let unknownProfilesSubject =  BehaviorSubject<[WorkspaceUser]>(value:[])
    
    let participantRepository = ParticipantRepository()
    
    let meetingId:Int
    let participantCountByTeamData:ParticipantCountByTeam
    
    let disposeBag = DisposeBag()
    
    init(data:ParticipantCountByTeam, meetingId:Int) {
        participantCountByTeamData = data
        self.meetingId = meetingId
        loadParticipantCountInfo()
    }
    
    func loadParticipantCountInfo() {
        participantRepository.loadParticipantCountInfo(teamId: participantCountByTeamData.teamId, meetingId: meetingId)
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                if let data = data {
                    owner.saveParticipantCountInfo(data: data)
                }
            }).disposed(by: disposeBag)
    }
    
    func saveParticipantCountInfo(data:ParticipantInfo) {
        var attendanceProfiles:[WorkspaceUser] = []
        var absenceProfiles:[WorkspaceUser] = []
        var unknownProfiles:[WorkspaceUser] = []
        for i in 0..<data.attends.count {
            attendanceProfiles.append(data.attends[i])
        }
        for i in 0..<data.absents.count {
            absenceProfiles.append(data.absents[i])
        }
        for i in 0..<data.unknowns.count {
            unknownProfiles.append(data.unknowns[i])
        }
        
        attendanceProfilesSubject.onNext(attendanceProfiles)
        absenceProfilesSubject.onNext(absenceProfiles)
        unknownProfilesSubject.onNext(unknownProfiles)
        

    }
}
