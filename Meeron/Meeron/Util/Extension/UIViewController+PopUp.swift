//
//  UIViewController+PopUp.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/27.
//

import Foundation
import UIKit

extension UIViewController {
    func showTwoButtonPopUpView(message:String, leftButtonTitle:String, rightButtonTitle:String, rightCompletion: @escaping ()->()) {
        let popUpView = TwoButtonPopUpViewController(nibName: "TwoButtonPopUpViewController", bundle: nil)
        popUpView.modalPresentationStyle = .overFullScreen
        present(popUpView, animated: false, completion: nil)
        popUpView.setupData(message:message, leftButtonTitle:leftButtonTitle, rightButtonTitle:rightButtonTitle, rightCompletion: rightCompletion)
    }
    
    func showOneButtonPopUpView(message:String, doneButtonTitle:String, doneCompletion: (()->())?) {
        let popUpView = OneButtonPopUpViewController(nibName: "OneButtonPopUpViewController", bundle: nil)
        popUpView.modalPresentationStyle = .overFullScreen
        present(popUpView, animated: false, completion: nil)
        
        popUpView.setupData(message: message, doneButtonTitle: doneButtonTitle, doneCompletion: doneCompletion)
    }
}
