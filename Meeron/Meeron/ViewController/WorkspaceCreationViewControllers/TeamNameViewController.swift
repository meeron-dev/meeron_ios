//
//  TeamNameViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/21.
//

import Foundation
import UIKit

class TeamNameViewController:UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamNameLimitLabelWidth: NSLayoutConstraint!
    
    var workspaceName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
