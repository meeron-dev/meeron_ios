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
    
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    
    let calendarVM = CalendarViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meetingTableView.dataSource = self
        meetingTableView.delegate = self
        meetingTableView.frame.size.height = view.frame.height/2
        
        configureUI()
        bindViewModel()
        
        
    }
    func configureUI() {
        configureCollectionViewLayout()
        configureAllCalendarLabel()
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
            let allCalendarVC = self.storyboard?.instantiateViewController(withIdentifier: "AllCalendarViewController")
            allCalendarVC?.modalPresentationStyle = .fullScreen
            self.present(allCalendarVC!, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        calendarVM.daysSubject.bind(to: calendarCollectionView.rx.items(cellIdentifier: "DateCell", cellType: DateCell.self)) { index, element, cell in
            cell.setData(date: element)
        }.disposed(by: disposeBag)
        
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

