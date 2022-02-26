//
//  HomeViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeViewController:UIViewController {
    
    @IBOutlet weak var meetingCollectionView: UICollectionView!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var uncheckUpdatesDoneMeetingDotView: UIView!
    @IBOutlet weak var bellBarButtonItem: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUI()
        setupCellPaging()
        initMeetingCollectionView()
        initTapAction()
    }
    
    func configureUI() {
        uncheckUpdatesDoneMeetingDotView.layer.cornerRadius = uncheckUpdatesDoneMeetingDotView.frame.width/2
        //bellBarButtonItem.image = UIImage(named: "ringBell")
    }
    
    func initTapAction() {
        calendarButton.rx.tap.bind {
            let calendarNavCV = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController")
            self.navigationController?.pushViewController(calendarNavCV!, animated: true)
        }.disposed(by: disposeBag)
    }
    
    func setupCellPaging() {
        meetingCollectionView.decelerationRate = .fast
        meetingCollectionView.isPagingEnabled = false
    }
    
    func initMeetingCollectionView() {
        meetingCollectionView.delegate = self
        meetingCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 31, bottom: 0, right: 31)
        layout.itemSize = CGSize(width: 253, height: 451)
        meetingCollectionView.collectionViewLayout = layout
    }
}

extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = meetingCollectionView.dequeueReusableCell(withReuseIdentifier: "MeetingCardCell", for: indexPath)
        return cell
    }
}

extension HomeViewController:UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        print(targetContentOffset.pointee)
        guard let layout = meetingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {return}
        let cellWidth = layout.itemSize.width
        let cellWidthIncludingSpacing:CGFloat
        let first = cellWidth - (self.view.frame.width - cellWidth - 2*layout.minimumLineSpacing)/2 + 31
        let estimatedIndex:CGFloat
        if targetContentOffset.pointee.x <= self.view.frame.width {
            cellWidthIncludingSpacing =  first
            estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        }else{
            cellWidthIncludingSpacing = cellWidth + layout.minimumLineSpacing
            estimatedIndex = (scrollView.contentOffset.x - first) / cellWidthIncludingSpacing
        }
        
        //let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        
        var index:Int
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        }else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        }else {
            index = Int(round(estimatedIndex))
        }
        
        
        if targetContentOffset.pointee.x <= self.view.frame.width {
            targetContentOffset.pointee = CGPoint(x: CGFloat(index)*cellWidthIncludingSpacing, y: 0)
        }else {
            targetContentOffset.pointee = CGPoint(x: CGFloat(index)*cellWidthIncludingSpacing + first, y: 0)
        }
        print("target:", targetContentOffset.pointee.x)
        
        
    }
}


