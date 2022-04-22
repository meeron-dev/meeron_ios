//
//  MyMeeronViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/03.
//

import Foundation
import UIKit
import SafariServices
import RxSwift

class MyMeeronViewController:UIViewController {
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    let myMeeronVM = MyMeeronViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.contentMode = .scaleAspectFill
        
        myMeeronVM.userProfileImageUrlSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, url in
                owner.setUserImage(profileImageUrl: url)
            }).disposed(by: disposeBag)
        
        myMeeronVM.userNameSubject
            .bind(to: userNameLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        myMeeronVM.loadUserNameInfo()
        myMeeronVM.loadUserImageInfo()
        
    }
    
    func setUserImage(profileImageUrl:String?) {
        if profileImageUrl == "" {
            profileImageView.image = UIImage(named: ImageNameConstant.profile)
            return
        }
        
        if let profileUrl = profileImageUrl {
            
            API().getImageResource(url: profileUrl) { imageResource in
                DispatchQueue.main.async {
                    self.profileImageView.kf.indicatorType = .activity
                    self.profileImageView.kf.setImage(with: imageResource)
                }
            }
            
        }
        if profileImageView.image == nil {
            profileImageView.image = UIImage(named: ImageNameConstant.profile)
        }
    }
    
    
    
    @IBAction func goProfileCreationView(_ sender: Any) {
        guard let workspaceId = UserDefaults.standard.string(forKey: "workspaceId") else {return }
        let workspaceParicipationProfileCreationVC = WorkspaceParicipationProfileCreationViewController(nibName: "WorkspaceParicipationProfileCreationViewController", bundle: nil)
        workspaceParicipationProfileCreationVC.workspaceParicipationProfileCreationVM = WorkspaceParicipationProfileCreationViewModel(workspaceId: workspaceId, type: .myMeeron)
        self.navigationController?.pushViewController(workspaceParicipationProfileCreationVC, animated: true)
    }
    
    
    @IBAction func goTermAgreeView(_ sender: Any) {
        let url = URL(string: URLConstant.terms)!
        let termAgreeSafariView = SFSafariViewController(url: url)
        present(termAgreeSafariView, animated: true, completion: nil)
    }
    
    @IBAction func goPersonalInformationCollectionAgreeView(_ sender: Any) {
        let url = URL(string: URLConstant.personalInformationCollection)!
        let personalInformationCollectionAgreeSafariView = SFSafariViewController(url: url)
        present(personalInformationCollectionAgreeSafariView, animated: true, completion: nil)
    }
}
