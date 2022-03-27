//
//  TeamParticipantAdditionalViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/27.
//

import Foundation
import UIKit

class TeamParticipantAdditionalViewController:UIViewController {
    
    @IBOutlet weak var profileViewController:UICollectionView!
    
    @IBOutlet weak var selectedProfileCountLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
