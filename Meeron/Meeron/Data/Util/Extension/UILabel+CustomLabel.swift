//
//  UILabel+CustomLabel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/02.
//

import Foundation
import UIKit

extension UILabel {
    static var meetingCreationNavigationItemTitleLabel:UILabel {
        let label = UILabel()
        label.text = "회의 생성"
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18)
        return label
    }
}
