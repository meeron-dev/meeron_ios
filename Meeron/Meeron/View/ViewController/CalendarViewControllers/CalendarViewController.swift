//
//  CalendarViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CalendarViewController:UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var prevMonthBtn: UIButton!
    @IBOutlet weak var nextMonthBtn: UIButton!
    @IBOutlet weak var allCalendarView: UIView!
    @IBOutlet weak var allCalendarLabel: UILabel!
    
    @IBOutlet weak var meetingTableView: UITableView!
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var selectedMeetingCountLabel: UILabel!
    
    
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    var calendarVM: CalendarViewModel!
    var calendarType: CalendarType!
    
    let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var workspaceNameLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView.delegate = self
        meetingTableView.frame.size.height = view.frame.height/2
        
        configureUI()
        bindViewModel()
        
        
    }
    
    func configureUI() {
        
        calendarVM.selectedDateSubject
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                owner.selectedDateLabel.text = date.toKoreanMonthDayString()
            }).disposed(by: disposeBag)
        
        calendarVM.selectedDateMeetingCountSubject
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, count in
                owner.selectedMeetingCountLabel.text = "\(count)개의 회의가 존재합니다."
            }).disposed(by: disposeBag)
        
        
        
        configureAllCalendarLabel()
        configureTableView()
    }
    
    func configureTableView() {
        meetingTableView.register(UINib(nibName: "CalendarMeetingCell", bundle: nil), forCellReuseIdentifier: "CalendarMeetingCell")
        
        calendarVM.selectedDateMeetingsSubject.bind(to: meetingTableView.rx.items) {[weak self] tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarMeetingCell", for: IndexPath(row: row, section: 0)) as! CalendarMeetingCell
            cell.setData(data: element, number: row+1) {
                self?.goMeetingView()
            }
            return cell
        }.disposed(by: disposeBag)
        
    }
    
    func goMeetingView() {
        let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let meetingNaviC = mainStroyboard.instantiateViewController(withIdentifier: "MeetingNavigationController")
        meetingNaviC.modalPresentationStyle = .fullScreen
        present(meetingNaviC, animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func bindViewModel() {
        prevMonthBtn.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.calendarVM.prevMonth()
            }).disposed(by: disposeBag)
        
        nextMonthBtn.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.calendarVM.nextMonth()
            }).disposed(by: disposeBag)
        
        configureCollectionViewLayout()
        
        let allCalendarTapGesture = UITapGestureRecognizer()
        allCalendarView.addGestureRecognizer(allCalendarTapGesture)
        allCalendarTapGesture.rx.event
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.goAllCalendarView()
            }).disposed(by: disposeBag)
        
        
        calendarCollectionView.register(UINib(nibName: "CalendarDateCell", bundle: nil), forCellWithReuseIdentifier: "CalendarDateCell")
        
        calendarVM.daysSubject.bind(to: calendarCollectionView.rx.items) {[weak self] collectionView, row, element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDateCell", for: IndexPath(row: row, section: 0)) as! CalendarDateCell
            
            guard let self = self else {
                return cell
            }
            cell.setData(data: element, selectedDate: self.calendarVM.selectedDate)
            return cell
        }.disposed(by: disposeBag)
        
        
        calendarCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let cell = owner.calendarCollectionView.cellForItem(at: indexPath) as! CalendarDateCell
                if let date = cell.dateString {
                    owner.calendarVM.selectedDateSubject.onNext(date)
                }
            }).disposed(by: disposeBag)
        
        
        calendarVM.monthSubject.bind(to: monthLabel.rx.text).disposed(by: disposeBag)
        calendarVM.yearSubject.bind(to: yearLabel.rx.text).disposed(by: disposeBag)
        calendarVM.calendarHeightSubject.bind(to: calendarHeight.rx.constant ).disposed(by: disposeBag)
        
        
        calendarVM.initDate()
        
    }
    
    func goAllCalendarView() {
        let allCalendarVC = AllCalendarViewController(nibName: "AllCalendarViewController", bundle: nil)
        
        allCalendarVC.allCalendarVM = AllCalendarViewModel(type: calendarType, nowYear: calendarVM.nowYear, nowMonth: calendarVM.nowMonth)
        
        allCalendarVC.delegate = self
        allCalendarVC.modalPresentationStyle = .fullScreen
        present(allCalendarVC, animated: false, completion: nil)
    }
    
    func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/7, height: 45)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        calendarCollectionView.collectionViewLayout = layout
    }
    
    func configureAllCalendarLabel() {
        let attributedString = NSMutableAttributedString(string: allCalendarLabel.text!)
        attributedString.addAttribute(.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length))
        attributedString.addAttribute(.baselineOffset, value: 2, range: NSRange.init(location: 0, length: attributedString.length))
        allCalendarLabel.attributedText = attributedString
    }
    
    
}

extension CalendarViewController: AllCalendarViewControllerDelegate {
    func passSelectedYearMonth(month: String, year: String) {
        calendarVM.changeDate(newMonth: month, newYear: year)
    }
}


