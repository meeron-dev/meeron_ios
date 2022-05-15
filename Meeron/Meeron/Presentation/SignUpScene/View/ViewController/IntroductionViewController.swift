//
//  IntroductionViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/18.
//

import Foundation
import UIKit
import RxSwift

struct Introduction {
    var title1:String
    var title2:String
    var title3:String
    var title4:String
    var subTitle:String
    var description1:String
    var description2:String
    var imageName:String
    var backGroundImageName:String
}

class IntroductionViewController:UIViewController{
    @IBOutlet weak var introductionContentCollectionView:UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    
    
    @IBOutlet weak var indicatorImageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    let indicatorImages = [UIImage(named: "icon_onboarding_pass1"),
                          UIImage(named: "icon_onboarding_pass2"),
                          UIImage(named: "icon_onboarding_pass3"),
                          UIImage(named: "icon_onboarding_pass4")]
    
    var introductions = [
        Introduction(title1: UserDefaults.standard.string(forKey: "userName")!, title2: "님,",title3: "이제 회의는 걱정마세요",title4: "", subTitle: "똑똑한 회의 관리, 미론과 함께", description1: "회의 준비부터 마무리까지 맡겨 주세요", description2: "", imageName: "illustration_onboarding_1", backGroundImageName: ""),
        Introduction(title1: "", title2: "출근 전", title3: "", title4: "1분이면 충분해요", subTitle: "주어진 회의를 한눈에", description1: "캘린더와 회의카드로 회의 일정을", description2: "확인하고 준비해보아요", imageName: "illustration_onboarding_2", backGroundImageName: ""),
        Introduction(title1: "", title2: "실속 없는", title3: "회의는", title4:" 그만", subTitle: "모두에게 명확한 회의", description1: "회의 전에 정보를 숙지하고,", description2: "본인의 상태를 공유할 수 있어요", imageName: "illustration_onboarding_3", backGroundImageName: "circle+triangle+X")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        configureUI()
        setupButton()
        
        
    }
    private func configureUI() {
        indicatorImageView.image = indicatorImages[0]
        startButton.addShadow()
    }
    
    private func setupButton() {
        startButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.goHomeView()
            }).disposed(by: disposeBag)
    }
    
    private func goHomeView() {
        let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = mainStroyboard.instantiateViewController(withIdentifier:"TabBarController") as! TabBarController
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true, completion: nil)
    }
    
    private func setupCollectionView() {
        introductionContentCollectionView.delegate = self
        introductionContentCollectionView.dataSource = self
        
        introductionContentCollectionView.register(UINib(nibName: "IntroductionCell", bundle: nil), forCellWithReuseIdentifier: "IntroductionCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: introductionContentCollectionView.frame.width, height: introductionContentCollectionView.frame.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        introductionContentCollectionView.collectionViewLayout = layout
        
    }
}

extension IntroductionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return introductions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroductionCell", for: indexPath) as! IntroductionCell
        cell.setData(data: introductions[indexPath.row])
        return cell
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = targetContentOffset.pointee.x/introductionContentCollectionView.frame.width
        indicatorImageView.image = indicatorImages[Int(page)]
        targetContentOffset.pointee.x = page*introductionContentCollectionView.frame.width

    }
    
}
extension IntroductionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: introductionContentCollectionView.frame.width, height: introductionContentCollectionView.frame.height)
    }
}
