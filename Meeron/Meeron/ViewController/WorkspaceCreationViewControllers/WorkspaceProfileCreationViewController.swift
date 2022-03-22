//
//  WorkspaceProfileCreationViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/21.
//

import Foundation
import UIKit


class WorkspaceProfileCreationViewController: UIViewController {
    
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var workspaceCreationData: WorkspaceCreation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func prev(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let teamNameVC = segue.destination as? TeamNameViewController else {return}
        
        teamNameVC.setData(data: workspaceCreationData)
    }
   
}
