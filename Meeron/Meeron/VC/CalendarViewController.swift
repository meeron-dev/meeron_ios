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
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var prevMonthBtn: UIButton!
    @IBOutlet weak var nextMonthBtn: UIButton!
    @IBOutlet weak var allCalendarView: UIView!
    @IBOutlet weak var allCalendarLabel: UILabel!
    
    @IBOutlet weak var meetingTableView: UITableView!
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    var calendarVM: CalendarViewModel!
    var calendarType: CalendarType!
    
    let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var workspaceNameLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meetingTableView.dataSource = self
        meetingTableView.delegate = self
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
        
        
        configureCollectionViewLayout()
        configureAllCalendarLabel()
        configureTableView()
    }
    
    func configureTableView() {
        calendarVM.selectedDateMeetingsSubject.bind(to: meetingTableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarMeetingCell", for: IndexPath(row: row, section: 0)) as! CalendarMeetingCell
            return cell
        }.disposed(by: disposeBag)
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func bindViewModel() {
        prevMonthBtn.rx.tap.bind {
            self.calendarVM.prevMonth()
        }.disposed(by: disposeBag)
        
        nextMonthBtn.rx.tap.bind {
            self.calendarVM.nextMonth()
        }.disposed(by: disposeBag)
        
        let allCalendarTapGesture = UITapGestureRecognizer()
        allCalendarView.addGestureRecognizer(allCalendarTapGesture)
        allCalendarTapGesture.rx.event.bind {_ in
            let allCalendarVC = self.storyboard?.instantiateViewController(withIdentifier: "AllCalendarViewController") as! AllCalendarViewController
            allCalendarVC.modalPresentationStyle = .fullScreen
            self.present(allCalendarVC, animated: false, completion: nil)
            
            allCalendarVC.nowDate.subscribe(onNext: {
                print($0, "월 선택")
            }).disposed(by: self.disposeBag)
            
        }.disposed(by: disposeBag)
        
        
        
        calendarVM.daysSubject.bind(to: calendarCollectionView.rx.items(cellIdentifier: "DateCell", cellType: DateCell.self)) { index, element, cell in
            cell.setData(data: element)
        }.disposed(by: disposeBag)
        
        
        calendarCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let cell = owner.calendarCollectionView.cellForItem(at: indexPath) as! DateCell
                if let date = cell.dateString {
                    owner.calendarVM.selectedDateSubject.onNext(date)
                }
            }).disposed(by: disposeBag)
        
        
        calendarVM.monthSubject.bind(to: monthLabel.rx.text).disposed(by: disposeBag)
        calendarVM.yearSubject.bind(to: yearLabel.rx.text).disposed(by: disposeBag)
        calendarVM.calendarHeightSubject.bind(to: calendarHeight.rx.constant ).disposed(by: disposeBag)
        
        
        calendarVM.initDate()
        
    }
    
    func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/7, height: 44)
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
/*
extension CalendarViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingInfoCell")!
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset:CGFloat = 600
        if scrollView.contentOffset.y > offset {
            scrollView.contentInset = UIEdgeInsets(top: self.meetingTableView.frame.height, left: 0, bottom: 0, right: 0)
        }else{
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

*/
