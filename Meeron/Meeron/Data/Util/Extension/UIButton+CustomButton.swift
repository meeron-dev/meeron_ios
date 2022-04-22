//
//  UIButton+ShadowEffect.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/02.
//

import Foundation
import UIKit

enum BottomButtonState {
    case enableGray
    case disableGray
    case enableBule
    case disableBule
}
enum BottomButtonType {
    case long
    case shortR
    case shortL
}


extension UIButton {
    
    func addShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
    }
    
    func setupBottomButton(type:BottomButtonType, state:BottomButtonState, title:String, view:UIView) {
        setAnchor(type: type, view: view)
        
        layer.cornerRadius = 5
        addShadow()
        setTitle(title, for: .normal)
        setButtonState(state: state)
    }
    
    func setAnchor(type:BottomButtonType, view:UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: ButtonConstant.bottomButtonBottom).isActive = true
        heightAnchor.constraint(equalToConstant: ButtonConstant.bottomButtonHeight).isActive = true
        
        switch type {
        case .long:
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ButtonConstant.longBottomButtonLeading).isActive = true
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ButtonConstant.longBottomButtonTrailing).isActive = true
        case .shortL:
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ButtonConstant.shortBottomButtonLeading).isActive = true
        case .shortR:
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ButtonConstant.shortBottomButtonTrailing).isActive = true
        }
        
        
    }
    
    func setButtonState(state:BottomButtonState) {
        switch state {
        case .enableGray:
            backgroundColor = .buttonGray
            setTitleColor(.textBalck, for: .normal)
            isUserInteractionEnabled = true
        case .disableGray:
            backgroundColor = .buttonGray
            setTitleColor(.darkGray, for: .normal)
            isUserInteractionEnabled = false
        case .enableBule:
            backgroundColor = .mrBlue
            setTitleColor(.white, for: .normal)
            isUserInteractionEnabled = true
            
        case .disableBule:
            backgroundColor = .buttonGray
            setTitleColor(.darkGray, for: .normal)
            isUserInteractionEnabled = false
        }
    }
    
}
