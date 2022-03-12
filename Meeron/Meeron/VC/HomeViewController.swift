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
    
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var expectMeetingCountLabel: UILabel!
    
    @IBOutlet weak var noExpectMeetingLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var meetingCreationBarButtonItem: UIBarButtonItem!
    
    let homeVM = HomeViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "워크스페이스"
        configureUI()
        setupCellPaging()
        setupMeetingCollectionView()
        initTapAction()
        
    }
    
    func configureUI() {
        uncheckUpdatesDoneMeetingDotView.layer.cornerRadius = uncheckUpdatesDoneMeetingDotView.frame.width/2
        
        todayDateLabel.text = Date().toMonthDateKoreanString()
        
        homeVM.todayMeetingCountSubject
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, count in
                if count > 10 {
                    owner.expectMeetingCountLabel.text = "진행 예정 10+"
                    owner.noExpectMeetingLabelWidth.constant = 0
                }else {
                    owner.expectMeetingCountLabel.text = "진행 예정 \(count)"
                    owner.noExpectMeetingLabelWidth.constant = 0
                    if count == 0 {
                        owner.noExpectMeetingLabelWidth.constant = 152
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    
    func initTapAction() {
        calendarButton.rx.tap.bind {
            let calendarVC = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
            calendarVC.modalPresentationStyle = .fullScreen
            self.present(calendarVC, animated: true, completion: nil)
            calendarVC.workspaceNameLabel.text = self.navigationItem.title
        }.disposed(by: disposeBag)
    }
    
    func setupCellPaging() {
        meetingCollectionView.decelerationRate = .fast
        meetingCollectionView.isPagingEnabled = false
    }
    
    func setupMeetingCollectionView() {
        //meetingCollectionView.delegate = self
        //meetingCollectionView.dataSource = self
        
        homeVM.todayMeetingsSubject.bind(to: meetingCollectionView.rx.items) { collectionView, row, element in
            if row < 10 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingCardCell", for: IndexPath(row: row, section: 0)) as! MeetingCardCell
                cell.setData(data: element)
                return cell
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoMeetingCardCell", for: IndexPath(row: row, section: 0))
                return cell
            }
            
        }.disposed(by: disposeBag)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 31, bottom: 0, right: 31)
        layout.itemSize = CGSize(width: 253, height: 451)
        meetingCollectionView.collectionViewLayout = layout
        
        homeVM.loadTodayMeeting()
    }
    
    @IBAction func createMeeting(_ sender: UIBarButtonItem) {
        let meetingCreationNaviC = self.storyboard?.instantiateViewController(withIdentifier: "MeetingCreationNavigationController")
        meetingCreationNaviC?.modalPresentationStyle = .fullScreen
        present(meetingCreationNaviC!, animated: true, completion: nil)
    }
    
}
/*
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}*/

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


