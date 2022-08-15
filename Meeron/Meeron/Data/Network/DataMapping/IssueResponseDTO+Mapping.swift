//
//  IssueResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/08/16.
//

import Foundation

struct IssueResponseDTO: Codable {
    let issueId:Int
    let content:String
}

extension IssueResponseDTO {
    func toDomain() -> Issue {
        return .init(issueId: issueId,
                     content: content)
    }
}
