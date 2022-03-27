//
//  WorkspaceErrorViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/22.
//

import UIKit

class WorkspaceErrorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func exit(_ sender: Any) {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.exit(0)
            
        }

    }

}
