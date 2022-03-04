//
//  MeetingAgendaCreationViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/04.
//

import Foundation
import RxSwift

class MeetingAgendaCreationViewModel {
    let agendasSubject = PublishSubject<[Agenda]>()
    var agendas:[Agenda] = [Agenda()]
    var nowAgendaIndex = 0
    
    func initAgendas() {
        agendasSubject.onNext(agendas)
    }
    
    func addAgenda() -> Bool {
        if agendas.count < 5 {
            agendas.append(Agenda())
            agendasSubject.onNext(agendas)
            nowAgendaIndex += 1
            return true
        }
        return false
    }
    
    func deleteAgenda() -> Bool {
        if agendas.count > 1 {
            agendas.remove(at: nowAgendaIndex)
            agendasSubject.onNext(agendas)
            nowAgendaIndex -= 1
            return true
        }
        return false
    }
    
    func getAgenda(index: Int) -> Agenda {
        return agendas[index]
    }
}
