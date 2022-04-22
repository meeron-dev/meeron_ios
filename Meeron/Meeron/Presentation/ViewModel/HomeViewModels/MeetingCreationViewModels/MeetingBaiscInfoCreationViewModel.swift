//
//  MeetingBaiscInfoCreationViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/07.
//

import Foundation
import RxSwift

class MeetingBaiscInfoCreationViewModel {
    
    var managers:[WorkspaceUser] = []
    var team:Team?
    var title:String = ""
    var purpose:String = ""
    
    let validTitleSubject = BehaviorSubject<Bool>(value: false)
    let validPurposeSubject = BehaviorSubject<Bool>(value: false)
    let validTeamSubject = BehaviorSubject<Bool>(value: false)
    
    let disposeBag = DisposeBag()
   
    var meetingCreationData:MeetingCreation?
    var meetingDateSubject = BehaviorSubject<String>(value: "")
    var meetingTimeSubject = BehaviorSubject<String>(value: "")
    
    func saveTitle(title:String) {
        self.title = title
        if title.trimmingCharacters(in: .whitespaces) != ""{
            self.meetingCreationData?.title = title
            validTitleSubject.onNext(true)
        }else {
            validTitleSubject.onNext(false)
        }
    }
    
    func savePurpose(purpose:String) {
        self.purpose = purpose
        if purpose.trimmingCharacters(in: .whitespaces) != "" {
            validPurposeSubject.onNext(true)
            self.meetingCreationData?.purpose = purpose
        }else {
            validPurposeSubject.onNext(false)
        }
    }
    
    func setTeam(team:Team?) {
        self.team = team
        if team != nil {
            validTeamSubject.onNext(true)
            self.meetingCreationData?.team = team!
        }else{
            validTeamSubject.onNext(false)
        }
    }
    
    func setManagers(managers:[WorkspaceUser]) {
        self.managers = managers
        self.meetingCreationData?.managers = managers
    }
    
    func getManagerNames(datas:[WorkspaceUser]) -> [String] {
        var managerNames:[String] = []
        _ = datas.map{ managerNames.append($0.nickname) }
        
        return managerNames
    }
    
    func setMeetingCreationData(data: MeetingCreation) {
        meetingCreationData = data
        meetingDateSubject.onNext(data.date.toKoreanDateString())
        meetingTimeSubject.onNext(data.startTime.toATimeString() + " ~ " + data.endTime.toATimeString())
        
    }
    
}
