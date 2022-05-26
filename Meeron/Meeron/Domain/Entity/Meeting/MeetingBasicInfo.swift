//
//  MeetingBasicInfo.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/27.
//

import Foundation

struct MeetingBasicInfo:Codable {
    let meetingId:Int
    let meetingName:String
    let meetingPurpose:String
    let meetingDate:String
    let startTime:String
    let endTime:String
    let operationTeamId: Int
    let operationTeamName: String
    let admins: [Admin]
}
