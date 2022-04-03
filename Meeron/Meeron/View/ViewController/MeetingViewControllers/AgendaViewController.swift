//
//  AgendaViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/31.
//

import Foundation
import UIKit
import RxSwift
import SafariServices

class AgendaViewController:UIViewController {
    
    @IBOutlet weak var scrollContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var agendaNumberCollectionView:UICollectionView!
    
    @IBOutlet weak var agendaTitleLabel:UILabel!
    
    @IBOutlet weak var issueTableView:UITableView!
    @IBOutlet weak var issueTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var documentTableView:UITableView!
    @IBOutlet weak var documentTableViewHeight: NSLayoutConstraint!
    
    var agendaVM: AgendaViewModel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupCollectionView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = .statusBarGray
    }
    
    func configureUI() {
        if #available(iOS 13, *) {
            view.addSubview(UIView.statusBar)
        }
        setAgendaTitle()
        setContentViewHeight()
    }
    
    func setContentViewHeight() {
        
        agendaVM.issuesSubject
            .map{CGFloat(($0.count)*50)}
            .bind(to: issueTableViewHeight.rx.constant)
            .disposed(by: disposeBag)
        
        agendaVM.documentsSubject
            .map{CGFloat(($0.count*40))}
            .bind(to: documentTableViewHeight.rx.constant)
            .disposed(by: disposeBag)
        
        agendaVM.newContentViewHeightSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, newHeight in
                owner.scrollContentViewHeight.constant = max(owner.view.safeAreaLayoutGuide.layoutFrame.height, newHeight)
            }).disposed(by: disposeBag)
            
    }
    
    func setAgendaTitle() {
        agendaVM.agendaTitleSubject.bind(to: agendaTitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setupCollectionView() {
        agendaNumberCollectionView.collectionViewLayout = UICollectionViewFlowLayout.numberCollectionViewlayout
        
        agendaNumberCollectionView.register(UINib(nibName: "MeetingNumberCell", bundle: nil), forCellWithReuseIdentifier: "MeetingNumberCell")
        agendaVM.agendaNumbersSubject.bind(to: agendaNumberCollectionView.rx.items) { [weak self] collectionView, row, element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingNumberCell", for: IndexPath(row: row, section: 0)) as! MeetingNumberCell
            
            guard let self = self  else {return cell}
            cell.setData(number: element, nowNumber: self.agendaVM.nowAgendaNumber)
            return cell
        }.disposed(by: disposeBag)
        
        agendaNumberCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { [weak self] owner, indexPath in
                self?.agendaVM.nowAgendaNumberSubject.onNext(indexPath.row+1)
            }).disposed(by: disposeBag)
    }
    
    func setupTableView() {
        agendaVM.issuesSubject.bind(to: issueTableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingAgendaIssueCell", for: IndexPath(row: row, section: 0)) as! MeetingAgendaIssueCell
            cell.issueNumberLabel.text = "\(row+1)"
            cell.issueLabel.text = element.content
            return cell
        }.disposed(by: disposeBag)
        
        agendaVM.documentsSubject.bind(to: documentTableView.rx.items) { [weak self] tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingAgendaDocumentCell", for: IndexPath(row: row, section: 0)) as! MeetingAgendaDocumentCell
            
            cell.documentLabel.text = element.fileUrl
            cell.documentUrl = element.fileUrl
            cell.delegate = self
            
            return cell
        }.disposed(by: disposeBag)
    }
    
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AgendaViewController: MeetingAgendaDocumentCellProtocol {
    func showDocument(url: String) {
        
    }
    
    
}
