//
//  MeetingResultViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/31.
//

import Foundation
import UIKit

class MeetingResultViewController:UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = .statusBarGray
    }
    
    func configureUI(){
        
        if #available(iOS 13, *) {
            view.addSubview(UIView.statusBar)
        }
    }
    
    @IBAction func goFeedbackView(_ sender: Any) {
        
    }
}
