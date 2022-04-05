//
//  TwoButtonPopUpViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/27.
//

import Foundation
import UIKit

class TwoButtonPopUpViewController:UIViewController {
    
    @IBOutlet weak var worksapceLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var subMessageLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    var rightCompletion:(()->())?
    var leftCompletion:(()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.cornerRadius = 5
        
        leftButton.layer.cornerRadius = 5
        leftButton.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner)
        
        rightButton.layer.cornerRadius = 5
        rightButton.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMaxYCorner)
        
        
        let attrString = NSMutableAttributedString(string: messageLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        messageLabel.attributedText = attrString
    }
    
    func setupData(message:String, subMessage:String, hasWorksapceLabel:Bool, leftButtonTitle:String, rightButtonTitle:String, leftCompletion: @escaping (()->()), rightCompletion:@escaping ()->()) {
        messageLabel.text = message
        rightButton.setTitle(rightButtonTitle, for: .normal)
        leftButton.setTitle(leftButtonTitle, for: .normal)
        self.rightCompletion = rightCompletion
        self.leftCompletion = leftCompletion
        subMessageLabel.text = subMessage
        if hasWorksapceLabel {
            worksapceLabel.text = UserDefaults.standard.string(forKey: "worksapceName")
        }else {
            worksapceLabel.text = ""
        }
    }
    
    func dismissView() {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func tapRightButton(_ sender: Any) {
        dismissView()
        rightCompletion?()
    }
    @IBAction func tapLeftButton(_ sender: Any) {
        dismissView()
        leftCompletion?()
    }
}

