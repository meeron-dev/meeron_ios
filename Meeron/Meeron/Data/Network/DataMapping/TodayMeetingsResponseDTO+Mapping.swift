//
//  TodayMeetingsResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/26.
//

import Foundation

struct TodayMeetingsResponseDTO: Codable {
    let meetings:[TodayMeetingResponseDTO]
}

extension TodayMeetingsResponseDTO {
    func toDomain() -> [TodayMeeting]  {
        return meetings.map{$0.toDomain()}
    }
}
