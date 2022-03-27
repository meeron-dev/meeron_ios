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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.cornerRadius = 5
    }
    func dismissView() {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func tapDoneButton() {
        dismissView()
    }
    func setupData(message:String, doneButtonTitle:String, doneCompletion: (()->())?){
        messageLabel.text = message
        doneButton.setTitle(doneButtonTitle, for: .normal)
    }
}
