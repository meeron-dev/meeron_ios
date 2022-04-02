//
//  AgendaViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/02.
//

import Foundation
import RxSwift
import Alamofire

class AgendaViewModel {
    
    let agendaNumbersSubject = BehaviorSubject<[Int]>(value: [])
    
    let agendaTitleSubject = BehaviorSubject<String>(value: "")
    let issuesSubject = BehaviorSubject<[Issue]>(value: [])
    let documentsSubject = BehaviorSubject<[File]>(value: [])
    
    
    let meetingId:Int
    let agendaCount:Int
    var nowAgendaNumber = 1
    var nowAgendaNumberSubject = BehaviorSubject<Int>(value: 1)
    
    let disposeBag = DisposeBag()
    
    let agendaRepository = AgendaRepository()
    
    init(meetingId:Int, agendaCount:Int) {
        self.meetingId = meetingId
        self.agendaCount = agendaCount
        
        agendaNumbersSubject.onNext((1..<agendaCount+1).map{Int($0)})
        
        nowAgendaNumberSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, number in
                owner.nowAgendaNumber = number
                owner.loadAgenda()
                owner.agendaNumbersSubject.onNext((1..<agendaCount+1).map{Int($0)})
            }).disposed(by: disposeBag)
        
        
        loadAgenda()
    }
    
    func loadAgenda() {
        agendaRepository.loadAgenda(meetingId: meetingId, agendaOrder: nowAgendaNumber)
            .withUnretained(self)
            .subscribe(onNext: { owner, agenda in
                if let agenda = agenda {
                    owner.agendaTitleSubject.onNext(agenda.agendaName)
                    owner.issuesSubject.onNext(agenda.issues)
                    owner.documentsSubject.onNext(agenda.files)
                    
                }
            }).disposed(by: disposeBag)
    }
    
}
