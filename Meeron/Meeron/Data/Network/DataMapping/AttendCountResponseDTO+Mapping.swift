//
//  AttendCountResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/05/26.
//

import Foundation

struct AttendCountResponseDTO: Codable {
    let attend: Int
    let absent: Int
    let unknown: Int
}

extension AttendCountResponseDTO {
    func toDomain() -> AttendCount {
        return .init(attend: attend,
                     absent: absent,
                     unknown: unknown)
    }
}
