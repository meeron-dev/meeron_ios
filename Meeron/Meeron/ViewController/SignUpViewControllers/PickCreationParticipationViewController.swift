//
//  PickCreationParticipationViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/19.
//

import Foundation
import UIKit
import RxSwift


class PickCreationParticipationViewController:UIViewController {
    
    @IBOutlet weak var nextButton:UIButton!
    
    @IBOutlet weak var creationButton:UIButton!
    @IBOutlet weak var creationLabel:UILabel!
    @IBOutlet weak var participationButton:UIButton!
    @IBOutlet weak var participationLabel:UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
    }
    
    func setupButton() {
        nextButton.addShadow()
        nextButton.isEnabled = false
        
        
        creationButton.rx.tap
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                if owner.creationButton.imageView?.image == UIImage(named: ImageNameConstant.unselectCreation) {
                    owner.creationButton.setImage(UIImage(named: ImageNameConstant.selectCreation), for: .normal)
                    owner.participationButton.setImage(UIImage(named: ImageNameConstant.unselectParticipation), for: .normal)
                    owner.nextButton.isEnabled = true
                }else {
                    owner.creationButton.setImage(UIImage(named: ImageNameConstant.unselectCreation), for: .normal)
                    owner.nextButton.isEnabled = false
                }
            }).disposed(by: disposeBag)
        
        participationButton.rx.tap
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                if owner.participationButton.imageView?.image == UIImage(named: ImageNameConstant.unselectParticipation) {
                    owner.participationButton.setImage(UIImage(named: ImageNameConstant.selectParticipation), for: .normal)
                    owner.creationButton.setImage(UIImage(named: ImageNameConstant.unselectCreation), for: .normal)
                    owner.nextButton.isEnabled = true
                }else {
                    owner.participationButton.setImage(UIImage(named: ImageNameConstant.unselectParticipation), for: .normal)
                    owner.nextButton.isEnabled = false
                }
            }).disposed(by: disposeBag)
        
        
    }
    
    @IBAction func next() {
        if creationButton.isEnabled {
            guard let WorkspaceCreationNaviC = self.storyboard?.instantiateViewController(withIdentifier: "WorkspaceCreationNavigationController") else {return}
            WorkspaceCreationNaviC.modalPresentationStyle = .fullScreen
            present(WorkspaceCreationNaviC, animated: true, completion: nil)
        }else {
            let WorkspaceParticipationSolutionVC = self.storyboard?.instantiateViewController(withIdentifier: "WorkspaceParticipationSolutionViewController") as! WorkspaceParticipationSolutionViewController
            WorkspaceParticipationSolutionVC.modalPresentationStyle = .fullScreen
            present(WorkspaceParticipationSolutionVC, animated: true, completion: nil)
        }
        
    }
}
