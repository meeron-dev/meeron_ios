//
//  TeamManagementViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/26.
//

import Foundation
import UIKit
import RxSwift

class TeamManagementViewController:UIViewController {
    
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton = UIButton()
        view.addSubview(doneButton)
        
        doneButton.setupBottomButton(type: .long, state: .enableGray, title: "팀 삭제하기", view: view)
        
        doneButton.rx.tap
            .subscribe(onNext: {
                self.tap()
            }).disposed(by: disposeBag)
        
        
    }
    func tap(){
        print("선택")
    }
    
    
}
