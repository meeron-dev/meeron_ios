//
//  FileResponseDTO+Mapping.swift
//  Meeron
//
//  Created by 심주미 on 2022/08/16.
//

import Foundation

struct FileResponseDTO: Codable {
    let fileId:Int
    let fileName:String
    let fileUrl:String
}

extension FileResponseDTO {
    func toDomain() -> File {
        return .init(fileId: fileId,
                     fileName: fileName,
                     fileUrl: fileUrl)
    }
}
