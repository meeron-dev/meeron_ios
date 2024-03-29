//
//  AgendaRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/02.
//

import Foundation
import Alamofire
import RxSwift


class AgendaRepository {
    
    let headers:HTTPHeaders = [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)]
    
    func loadAgenda(meetingId:Int, agendaOrder:Int) -> Observable<Agenda?> {
        let resource = Resource<AgendaResponseDTO>(url: URLConstant.meetings+"/\(meetingId)/agendas/\(agendaOrder)", parameter: [:], headers: headers, method: .get, encodingType: .URLEncoding)
        
        return API.requestData(resource: resource)
            .map{$0?.toDomain()}
    }
    
}
