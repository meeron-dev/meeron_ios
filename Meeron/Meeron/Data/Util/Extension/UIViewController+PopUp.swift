//
//  UIViewController+PopUp.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/27.
//

import Foundation
import UIKit

extension UIViewController {
    func showTwoButtonPopUpView(message:String, subMessage:String, hasWorksapceLabel:Bool, leftButtonTitle:String, rightButtonTitle:String, leftComletion: @escaping ()->(), rightCompletion: @escaping ()->()) {
        let popUpView = TwoButtonPopUpViewController(nibName: "TwoButtonPopUpViewController", bundle: nil)
        popUpView.modalPresentationStyle = .overFullScreen
        present(popUpView, animated: false, completion: nil)
        popUpView.setupData(message:message, subMessage: subMessage, hasWorksapceLabel: hasWorksapceLabel, leftButtonTitle:leftButtonTitle, rightButtonTitle:rightButtonTitle, leftCompletion: leftComletion, rightCompletion: rightCompletion)
    }
    
    func showOneButtonPopUpView(message:String, hasWorkspaceLabel:Bool, doneButtonTitle:String, doneCompletion: (()->())?) {
        let popUpView = OneButtonPopUpViewController(nibName: "OneButtonPopUpViewController", bundle: nil)
        popUpView.modalPresentationStyle = .overFullScreen
        present(popUpView, animated: false, completion: nil)
        
        popUpView.setupData(message: message, hasWorkspaceLabel: hasWorkspaceLabel, doneButtonTitle: doneButtonTitle, doneCompletion: doneCompletion)
    }
}
