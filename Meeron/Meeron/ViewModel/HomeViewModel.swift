//
//  HomeViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/27.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    var todayMeetings:[TodayMeeting] = []
    let todayMeetingsSubject = PublishSubject<[TodayMeeting]>()
    
    let todayMeetingCountSubject = BehaviorSubject<Int>(value: 0)
    
    let meetingRepository = MeetingRepository()
    let disposeBag = DisposeBag()
    
    func loadTodayMeeting() {
        meetingRepository.loadTodayMeeting()
            .withUnretained(self)
            .subscribe(onNext: { owner, meetings in
                if let meetings = meetings {
                    print(meetings)
                    if meetings.meetings.count <= 10 {
                        owner.todayMeetings = meetings.meetings
                        owner.todayMeetingsSubject.onNext(meetings.meetings)
                        owner.todayMeetingCountSubject.onNext(meetings.meetings.count)
                    }else {
                        owner.todayMeetings = Array(meetings.meetings[..<11])
                        owner.todayMeetingsSubject.onNext(Array(meetings.meetings[..<11]))
                        owner.todayMeetingCountSubject.onNext(meetings.meetings.count)
                    }
                    
                }
            }).disposed(by: disposeBag)
    }
}
