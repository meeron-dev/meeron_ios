//
//  TermsViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/18.
//

import Foundation
import UIKit
import SafariServices
import RxSwift

class TermsViewController:UIViewController {
    
    @IBOutlet weak var nextButton:UIButton!
    
    @IBOutlet weak var allAgreeImageView:UIImageView!
    @IBOutlet weak var termAgreeImageView:UIImageView!
    @IBOutlet weak var personalInformationCollectionAgreeImageView:UIImageView!
    
    @IBOutlet weak var termAgreeLabel:UILabel!
    @IBOutlet weak var personalInformationCollectionAgreeLabel:UILabel!
    
    let agreeTermSubject = BehaviorSubject<Bool>(value: false)
    let agreePersonalInformationCollectionSubject = BehaviorSubject<Bool>(value: false)
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        addTapGesture()
        
        Observable.combineLatest(agreeTermSubject, agreePersonalInformationCollectionSubject) {
            $0 && $1
        }
        .withUnretained(self)
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { owner, allAgree in
            owner.nextButton.isEnabled = allAgree
            if allAgree {
                owner.allAgreeImageView.image = UIImage(named: ImageNameConstant.checkTerms)
            }else {
                owner.allAgreeImageView.image = UIImage(named: ImageNameConstant.uncheckTerms)
            }
        }).disposed(by: disposeBag)
        
    }
    
    func addTapGesture() {
        let allAgreeTapGesture = UITapGestureRecognizer()
        allAgreeTapGesture.addTarget(self, action: #selector(tapAllAgreeImageView))
        allAgreeImageView.isUserInteractionEnabled = true
        allAgreeImageView.addGestureRecognizer(allAgreeTapGesture)
        
        
        let termAgreeTapGesture = UITapGestureRecognizer()
        termAgreeTapGesture.addTarget(self, action: #selector(tapTermAgreeImageView))
        termAgreeImageView.isUserInteractionEnabled = true
        termAgreeImageView.addGestureRecognizer(termAgreeTapGesture)
        
        let personalInformationCollectionAgreeTapGesture = UITapGestureRecognizer()
        personalInformationCollectionAgreeTapGesture.addTarget(self, action: #selector(tapPersonalInformationCollectionAgreeImageView))
        personalInformationCollectionAgreeImageView.isUserInteractionEnabled = true
        personalInformationCollectionAgreeImageView.addGestureRecognizer(personalInformationCollectionAgreeTapGesture)
    }
    
    @objc func tapAllAgreeImageView() {
        if allAgreeImageView.image == UIImage(named: ImageNameConstant.uncheckTerms) {
            
            allAgreeImageView.image = UIImage(named: ImageNameConstant.checkTerms)
            termAgreeImageView.image = UIImage(named: ImageNameConstant.checkTerms)
            personalInformationCollectionAgreeImageView.image = UIImage(named: ImageNameConstant.checkTerms)
            
            agreeTermSubject.onNext(true)
            agreePersonalInformationCollectionSubject.onNext(true)
        }else {
            allAgreeImageView.image = UIImage(named: ImageNameConstant.uncheckTerms)
            termAgreeImageView.image = UIImage(named: ImageNameConstant.uncheckTerms)
            personalInformationCollectionAgreeImageView.image = UIImage(named: ImageNameConstant.uncheckTerms)
            agreeTermSubject.onNext(false)
            agreePersonalInformationCollectionSubject.onNext(false)
        }
        
    }
    
    @objc func tapTermAgreeImageView() {
        if termAgreeImageView.image == UIImage(named: ImageNameConstant.uncheckTerms) {
            termAgreeImageView.image = UIImage(named: ImageNameConstant.checkTerms)
            agreeTermSubject.onNext(true)
        }else {
            termAgreeImageView.image = UIImage(named: ImageNameConstant.uncheckTerms)
            agreeTermSubject.onNext(false)
        }
        
    }
    
    @objc func tapPersonalInformationCollectionAgreeImageView() {
        if personalInformationCollectionAgreeImageView.image == UIImage(named: ImageNameConstant.checkTerms) {
            personalInformationCollectionAgreeImageView.image = UIImage(named: ImageNameConstant.uncheckTerms)
            agreePersonalInformationCollectionSubject.onNext(false)
        }else {
            personalInformationCollectionAgreeImageView.image = UIImage(named: ImageNameConstant.checkTerms)
            agreePersonalInformationCollectionSubject.onNext(true)
        }
    }
    
    private func configureUI() {
        nextButton.addShadow()
        nextButton.isEnabled = true
    }
    
    @IBAction func goTermAgreeView(_ sender: Any) {
        let url = URL(string: "https://test.com")!
        let termAgreeSafariView = SFSafariViewController(url: url)
        present(termAgreeSafariView, animated: true, completion: nil)
    }
    
    @IBAction func goPersonalInformationCollectionAgreeView(_ sender: Any) {
        let url = URL(string: "https://test.com")!
        let personalInformationCollectionAgreeSafariView = SFSafariViewController(url: url)
        present(personalInformationCollectionAgreeSafariView, animated: true, completion: nil)
    }
    
}
