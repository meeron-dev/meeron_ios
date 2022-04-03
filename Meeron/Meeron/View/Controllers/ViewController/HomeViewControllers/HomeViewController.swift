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
    
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var todayMeetingCountLabel: UILabel!
    
    @IBOutlet weak var noExpectMeetingLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var meetingCreationBarButtonItem: UIBarButtonItem!
    
    let homeVM = HomeViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeVM.failTokenSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.goLoginView()
            }).disposed(by: disposeBag)
        
        
        configureUI()
        setupCellPaging()
        setupMeetingCollectionView()
        initTapAction()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        homeVM.loadTodayMeeting()
    }
    
    func goLoginView() {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: false, completion: nil)
    }
    
    func configureUI() {
        
        homeVM.workspaceNameSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                owner.navigationItem.title = text
            }).disposed(by: disposeBag)

        
        todayDateLabel.text = Date().toMonthDayKoreanString()
        
        homeVM.todayMeetingCountSubject
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, count in
                if count > 10 {
                    owner.todayMeetingCountLabel.text = "10+"
                    owner.noExpectMeetingLabelWidth.constant = 0
                }else {
                    owner.todayMeetingCountLabel.text = "\(count)"
                    owner.noExpectMeetingLabelWidth.constant = 0
                    if count == 0 {
                        owner.noExpectMeetingLabelWidth.constant = 152
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    
    func initTapAction() {
        calendarButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.goCalendarView()
            }).disposed(by: disposeBag)
    }
    
    func goCalendarView() {
        let calendarVC = CalendarViewController(nibName: "CalendarViewController", bundle: nil)
        calendarVC.calendarVM = CalendarViewModel(type: .workspace)
        calendarVC.calendarType = .workspace
        
        calendarVC.modalPresentationStyle = .fullScreen
        self.present(calendarVC, animated: true, completion: nil)
        calendarVC.workspaceNameLabel.text = self.navigationItem.title
    }
    
    func setupCellPaging() {
        meetingCollectionView.decelerationRate = .fast
        meetingCollectionView.isPagingEnabled = false
    }
    
    func setupMeetingCollectionView() {
        
        meetingCollectionView.delegate = self
        
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
        
        
        meetingCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                if indexPath.row < 10 {
                    let cell = owner.meetingCollectionView.cellForItem(at: indexPath) as! MeetingCardCell
                    owner.goMeetingView(meetingId: cell.meetingId)
                }
                
            }).disposed(by: disposeBag)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 31, bottom: 0, right: 31)
        layout.itemSize = CGSize(width: 253, height: meetingCollectionView.frame.height-25)
        meetingCollectionView.collectionViewLayout = layout
        
        homeVM.loadUser()
    }
    
    func goMeetingView(meetingId:Int) {
        let meetingNaviC = self.storyboard?.instantiateViewController(withIdentifier: "MeetingNavigationController") as! UINavigationController
        meetingNaviC.modalPresentationStyle = .fullScreen
        let meetingVC = meetingNaviC.viewControllers.first as! MeetingViewController
        meetingVC.meetingVM = MeetingViewModel(meetingId: meetingId)
        
        
        present(meetingNaviC, animated: true, completion: nil)
    }
    
    @IBAction func createMeeting(_ sender: UIBarButtonItem) {
        let meetingCreationNaviC = self.storyboard?.instantiateViewController(withIdentifier: "MeetingCreationNavigationController")
        meetingCreationNaviC?.modalPresentationStyle = .fullScreen
        present(meetingCreationNaviC!, animated: true, completion: nil)
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


