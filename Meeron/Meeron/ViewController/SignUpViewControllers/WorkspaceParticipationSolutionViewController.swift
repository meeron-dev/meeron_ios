//
//  WorkspaceParticipationSolutionViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/22.
//

import Foundation
import UIKit

class WorkspaceParticipationSolutionViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.addShadow()
    }
    
    @IBAction func close(_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
