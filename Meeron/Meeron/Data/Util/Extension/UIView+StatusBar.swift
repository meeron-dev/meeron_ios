//
//  UIView+StausBar.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/31.
//

import Foundation
import UIKit
extension UIView {
    static var statusBar:UIView {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        let statusBar = UIView(frame: (keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
        statusBar.backgroundColor = .statusBarGray
        return statusBar
    }
}

