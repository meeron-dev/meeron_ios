//
//  UIViewController+DismissKeyboard.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/25.
//

import Foundation
import UIKit

extension UIViewController {
    func addDismissKeyboardTapper() {
        let tapper = UITapGestureRecognizer(target: self, action:#selector(dismissK))
        view.addGestureRecognizer(tapper)
    }
    
    @objc func dismissK() {
        view.endEditing(true)
    }
}
