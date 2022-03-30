//
//  TeamCreationResultViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/30.
//

import Foundation
import UIKit
import RxSwift

class TeamCreationResultViewController:UIViewController {
    
    @IBOutlet weak var teamNameLabel:UILabel!
    @IBOutlet weak var participantCountLabel:UILabel!
    @IBOutlet weak var doneButton:UIButton!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dismissView()
            }).disposed(by: disposeBag)
    }
    
    func dismissView() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func setData(teamName:String, participantCount:Int) {
        teamNameLabel.text = teamName
        participantCountLabel.text = "\(participantCount)명"
    }
}
