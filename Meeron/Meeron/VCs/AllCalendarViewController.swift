//
//  AllCalendarViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/26.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AllCalendarViewController:UIViewController {
    
    @IBOutlet weak var yearTableView:UITableView!
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
