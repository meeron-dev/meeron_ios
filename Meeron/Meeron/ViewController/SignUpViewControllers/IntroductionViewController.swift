//
//  IntroductionViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/18.
//

import Foundation
import UIKit

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
    
    
    let indicatorImages = [UIImage(named: "icon_onboarding_pass1"),
                          UIImage(named: "icon_onboarding_pass2"),
                          UIImage(named: "icon_onboarding_pass3"),
                          UIImage(named: "icon_onboarding_pass4")]
    
    var introductions:[Introduction]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        configureUI()
        
        
    }
    private func configureUI() {
        indicatorImageView.image = indicatorImages[0]
        startButton.addShadow()
    }
    
    private func setupCollectionView() {
        introductionContentCollectionView.delegate = self
        introductionContentCollectionView.dataSource = self
        
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
        let page = targetContentOffset.pointee.x/scrollView.frame.width
        indicatorImageView.image = indicatorImages[Int(page)]

    }
    
}
