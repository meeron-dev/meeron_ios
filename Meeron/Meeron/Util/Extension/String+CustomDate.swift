//
//  String+CustomDate.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/24.
//

import Foundation

extension String {
    func getDay() -> String{
        return String(Int(String(self.split(separator: "-")[2]))!)
    }
}
