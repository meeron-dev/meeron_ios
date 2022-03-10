//
//  MeetingAgendaCreationViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/04.
//

import Foundation
import RxSwift
import RxRelay

class MeetingAgendaCreationViewModel {
    let agendasSubject = PublishSubject<[Agenda]>()
    var agendas:[Agenda] = [Agenda()]
    
    var nowAgendaIndex = 0
    var nowAgendaIndexSubject = BehaviorSubject<Int>(value: 0)
    var nowAgendaSubject = PublishSubject<Agenda>()
    
    var nowIssueIndex = 0
    
    var agendaIssueSubject = PublishSubject<[String]>()
    var agendaDocumentSubject = PublishSubject<[Data]>()
    
    var meetingCreationData:MeetingCreation?
    let meetingDateSubject = BehaviorSubject<String>(value: "")
    let meetingTimeSubject = BehaviorSubject<String>(value: "")
    let meetingTitleSubject = BehaviorSubject<String>(value: "")
    
    let disposeBag = DisposeBag()
    
    func initAgendas() {
        agendasSubject.onNext(agendas)
        nowAgendaIndexSubject.onNext(nowAgendaIndex)
        agendaIssueSubject.onNext(agendas[nowAgendaIndex].issue)
        
        agendasSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, agendas in
                owner.meetingCreationData?.agendas = agendas
            }).disposed(by: disposeBag)
        
        nowAgendaIndexSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, index in
                owner.nowAgendaIndex = index
                owner.nowAgendaSubject.onNext(owner.agendas[owner.nowAgendaIndex])
                owner.agendaIssueSubject.onNext(owner.agendas[owner.nowAgendaIndex].issue)
                owner.agendaDocumentSubject.onNext(owner.agendas[owner.nowAgendaIndex].document)
            
            }).disposed(by: disposeBag)
        
    }
    
    func addAgenda() -> Bool {
        if agendas.count < 5 {
            agendas.append(Agenda())
            agendasSubject.onNext(agendas)
            nowAgendaIndex = agendas.count-1
            nowAgendaIndexSubject.onNext(nowAgendaIndex)
            return true
        }
        return false
    }
    
    func deleteAgenda() -> Bool {
        if agendas.count > 1 {
            agendas.remove(at: nowAgendaIndex)
            agendasSubject.onNext(agendas)
            if nowAgendaIndex == agendas.count {
                nowAgendaIndex -= 1
            }
            nowAgendaIndexSubject.onNext(nowAgendaIndex)
            return true
        }
        return false
    }
    
    func addIssue() {
        agendas[nowAgendaIndex].issue.append("")
        agendasSubject.onNext(agendas)
        agendaIssueSubject.onNext(agendas[nowAgendaIndex].issue)
    }
    
    func addDocument() {
        agendas[nowAgendaIndex].document.append(Data())
        agendasSubject.onNext(agendas)
        agendaDocumentSubject.onNext(agendas[nowAgendaIndex].document)
    }
    
    func getAgenda() -> Agenda {
        return agendas[nowAgendaIndex]
    }
    
    func saveAgendaTitle(title:String) {
        agendas[nowAgendaIndex].title = title
        agendasSubject.onNext(agendas)
    }
    
    func saveAgendaIssue(issue:String, index:Int) {
        if index < agendas[nowAgendaIndex].issue.count {
            agendas[nowAgendaIndex].issue[index] = issue
            agendasSubject.onNext(agendas)
        }
    }
    
    func deleteIssue(index:Int) {
        agendas[nowAgendaIndex].issue.remove(at: index)
        agendasSubject.onNext(agendas)
        agendaIssueSubject.onNext(agendas[nowAgendaIndex].issue)
    }
    
    func setMeetingCreationData(data: MeetingCreation) {
        meetingCreationData = data
        meetingDateSubject.onNext(data.date.changeMeetingCreationDateToKoreanString())
        meetingTimeSubject.onNext(data.startTime.changeMeetingCreationTimeToAString() + " ~ " + data.endTime.changeMeetingCreationTimeToAString())
        meetingTitleSubject.onNext(data.title)
    }
}
