//
//  Meeting.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/26.
//

import Foundation

struct Meeting:Codable {
    let meetingId: Int
    let startDate: String
    let startTime: String
    let endTime: String
    let meetingName: String
    let purpose: String
    let place: String?
}
