//
//  TwoButtonPopUpViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/27.
//

import Foundation
import UIKit

class TwoButtonPopUpViewController:UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    var rightCompletion:(()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.cornerRadius = 5
    }
    
    func setupData(message:String, leftButtonTitle:String, rightButtonTitle:String, rightCompletion:@escaping ()->()) {
        messageLabel.text = message
        rightButton.setTitle(rightButtonTitle, for: .normal)
        leftButton.setTitle(leftButtonTitle, for: .normal)
        self.rightCompletion = rightCompletion
        
    }
    
    func dismissView() {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func tapRightButton(_ sender: Any) {
        rightCompletion?()
        dismissView()
    }
    @IBAction func tapLeftButton(_ sender: Any) {
        dismissView()
    }
}

