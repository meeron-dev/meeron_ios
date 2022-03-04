//
//  UIButton+ShadowEffect.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/02.
//

import Foundation
import UIKit

extension UIButton {
    
    func addShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
    }
}
