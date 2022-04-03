//
//  OneButtonPopUpViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/27.
//

import Foundation
import UIKit

class OneButtonPopUpViewController:UIViewController {
    
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var doneButton:UIButton!
    
    var doneCompletion:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.cornerRadius = 5
        doneButton.layer.cornerRadius = 5
        doneButton.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
    func dismissView() {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func tapDoneButton() {
        doneCompletion?()
        dismissView()
    }
    func setupData(message:String, doneButtonTitle:String, doneCompletion: (()->())?){
        messageLabel.text = message
        doneButton.setTitle(doneButtonTitle, for: .normal)
        self.doneCompletion = doneCompletion
    }
}
