//
//  AllCalendarViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/26.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


protocol AllCalendarViewControllerDelegate {
    func passSelectedYearMonth(month:String, year:String)
}

class AllCalendarViewController:UIViewController {
    
    @IBOutlet weak var yearTableView:UITableView!
    
    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewContainerView: UIView!
    
    var delegate:AllCalendarViewControllerDelegate?
    
    var allCalendarVM:AllCalendarViewModel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupTableView()
        
    }
    func setupTableView() {
        
        allCalendarVM.yearMeetingCountSubject.bind(to: yearTableView.rx.items) { [weak self] tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllCalendarYearCell") as! AllCalendarYearCell
            guard let self = self else {return cell}
            cell.setData(data: element, nowYear: self.allCalendarVM.nowYear)
            return cell
        }.disposed(by: disposeBag)
        
        yearTableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let cell = owner.yearTableView.cellForRow(at: indexPath) as! AllCalendarYearCell
                let yearLabelString = cell.yearLabel.text!
                owner.allCalendarVM.nowYear = String(yearLabelString.dropLast(yearLabelString.count-1))
            }).disposed(by: disposeBag)
        
    }
    
    
    func closeAllCalendarView() {
        delegate?.passSelectedYearMonth(month: allCalendarVM.nowMonth, year:allCalendarVM.nowYear)
        dismiss(animated: true, completion: nil)
    }
    
    func setupCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:UIScreen.main.bounds.width/3, height: collectionViewContainerView.bounds.height/6)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        monthCollectionView.collectionViewLayout = layout
        
        allCalendarVM.monthMeetingCountSubject.bind(to: monthCollectionView.rx.items) { [weak self] collectionView, row, element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllCalendarMonthCell", for: IndexPath(row: row, section: 0)) as! AllCalendarMonthCell
            guard let self = self else { return cell }
            cell.setData(data: element, nowMonth: self.allCalendarVM.nowMonth)
            return cell
        }.disposed(by: disposeBag)
        
        monthCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, index in
                owner.allCalendarVM.nowMonth = String(index.row+1)
                owner.closeAllCalendarView()
            }).disposed(by: disposeBag)
        
    }
    
    
    @IBAction func closeView(_ sender: Any) {
        delegate?.passSelectedYearMonth(month: Date().toMonthString(), year: Date().toYearString())
        self.dismiss(animated: false, completion: nil)
    }
    
    
}
