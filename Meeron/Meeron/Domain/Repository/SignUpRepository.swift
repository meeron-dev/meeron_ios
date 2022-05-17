//
//  SignUpRepository.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/20.
//

import Foundation
import RxSwift

protocol SignUpRepository {
    func saveUserName(name:String) -> Observable<Bool>
}
