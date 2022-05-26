//
//  GetTodayMeetingUseCase.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/26.
//

import Foundation
import RxSwift

class GetTodayMeetingUseCase {
    
    private let meetingRepository = MeetingRepository()
    
    func execute() -> Observable<[TodayMeeting]?>{
        return meetingRepository.loadTodayMeeting()
    }
}
