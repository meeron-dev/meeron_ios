//
//  ContactViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/04.
//

import Foundation
import UIKit

class ContactViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
