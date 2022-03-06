//
//  MeetingAgendaCreationViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/03.
//

import Foundation
import UIKit
import RxSwift

class MeetingAgendaCreationViewController: UIViewController {
    @IBOutlet weak var prevButton:UIButton!
    @IBOutlet weak var nextButton:UIButton!
    
    @IBOutlet weak var meetingDate:UILabel!
    @IBOutlet weak var meetingTime:UILabel!
    @IBOutlet weak var meetingTitle:UILabel!
    
    
    @IBOutlet weak var agendaTitleTextField: UITextField!
    @IBOutlet weak var agendaTitleLabel: UILabel!
    
    @IBOutlet weak var addAgendaButton:UIButton!
    @IBOutlet weak var deleteAgendaButton:UIButton!
    @IBOutlet weak var addAgendaButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var deleteAgendaButtonWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var agendaSelectBarCollectionView: UICollectionView!
    
    @IBOutlet weak var addIssueButton: UIButton!
    @IBOutlet weak var agendaIssueTableView: UITableView!
    @IBOutlet weak var agendaDocumentTableView: UITableView!
    @IBOutlet weak var agendaIssueTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var agendaDocumentTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addDocumentButton: UIButton!
    
    @IBOutlet weak var agendaContentViewHeight: NSLayoutConstraint!
    var scrollViewOriginalOffset = CGPoint(x: 0, y: 0)
    
    let meetingAgendaCreationVM = MeetingAgendaCreationViewModel()
    
    @IBOutlet weak var agendaContentView: UIView!
    
    @IBOutlet weak var agendaContentScrollView: UIScrollView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUI()
        setupCollectionView()
        setupTableView()
        saveContent()
        setupKeyboardNoti()
        meetingAgendaCreationVM.initAgendas()
        
    }
    
    func setupKeyboardNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        scrollViewOriginalOffset = agendaContentScrollView.contentOffset
        agendaContentScrollView.setContentOffset(CGPoint(x: 0, y: 250+scrollViewOriginalOffset.y), animated: true)
        
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        agendaContentScrollView.setContentOffset(scrollViewOriginalOffset, animated: true)
    }
    
    private func setupTableView() {
        
        meetingAgendaCreationVM.agendaIssueSubject.bind(to: agendaIssueTableView.rx.items) { tableView, row, element in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaIssueCell", for: indexPath) as! AgendaIssueCell
            cell.agendaIssueTextField.text = element
            cell.setCellInfo(vm: self.meetingAgendaCreationVM, index: row)
            return cell
        }.disposed(by: disposeBag)
        
        meetingAgendaCreationVM.agendaDocumentSubject.bind(to: agendaDocumentTableView.rx.items) {tableView, row, element in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaDocumentCell", for: indexPath) as! AgendaDocumentCell
            return cell
        }.disposed(by: disposeBag)
        
        
        meetingAgendaCreationVM.agendaIssueSubject
            .map{$0.count}
            .subscribe(onNext: {
                self.agendaIssueTableViewHeight.constant = CGFloat($0*60)
                self.agendaContentViewHeight.constant = 700 + self.agendaIssueTableViewHeight.constant + self.agendaDocumentTableViewHeight.constant
            }).disposed(by: disposeBag)
        
        meetingAgendaCreationVM.agendaDocumentSubject
            .map{$0.count}
            .subscribe(onNext: {
                self.agendaDocumentTableViewHeight.constant = CGFloat($0*60)
                self.agendaContentViewHeight.constant = 700 + self.agendaIssueTableViewHeight.constant + self.agendaDocumentTableViewHeight.constant
            }).disposed(by: disposeBag)
    }
    
    
    
    private func setupCollectionView() {
        setupCollectionViewLayout()
        
        meetingAgendaCreationVM.agendasSubject.bind(to: agendaSelectBarCollectionView.rx.items) { collectionView, row, element in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AgendaSelectBarCell", for: indexPath) as! AgendaSelectBarCell
            cell.agendaNumber.text = String(row+1)
            cell.setVM(vm: self.meetingAgendaCreationVM)
            return cell
        }.disposed(by: disposeBag)
        
    }
    
    private func setupCollectionViewLayout() {
        let agendaSelectBarCollectionViewlayout = UICollectionViewFlowLayout()
        agendaSelectBarCollectionViewlayout.itemSize = CGSize(width: 44, height: 44)
        agendaSelectBarCollectionViewlayout.scrollDirection = .horizontal
        agendaSelectBarCollectionViewlayout.minimumLineSpacing = 0
        agendaSelectBarCollectionViewlayout.minimumInteritemSpacing = 0
        
        agendaSelectBarCollectionView.collectionViewLayout = agendaSelectBarCollectionViewlayout
    }
    
    private func configureUI() {
        self.navigationItem.titleView = UILabel.meetingCreationNavigationItemTitleLabel
        
        prevButton.addShadow()
        nextButton.addShadow()
        
        addTapGesture()
        
        
        meetingAgendaCreationVM.nowAgendaSubject.subscribe(onNext: {
            self.setAgendaContent(data: $0)
        }).disposed(by: disposeBag)
        
        meetingAgendaCreationVM.nowAgendaIndexSubject.subscribe(onNext: {
            print($0+1)
            if $0+1 == 1 {
                self.agendaTitleLabel.text = "핵심 아젠다"
            }else {
                self.agendaTitleLabel.text = "아젠다"
            }
            self.changeAgendaButtonWidth(index: $0)
        }).disposed(by: disposeBag)
    }
    
    private func changeAgendaButtonWidth(index:Int) {
        if index == 0 {
            deleteAgendaButton.setImage(UIImage(), for: .disabled)
            addAgendaButton.setImage(UIImage(named: "ic_create a meeting_agenda plus"), for: .normal)
            deleteAgendaButtonWidth.constant = 0
            deleteAgendaButton.isEnabled = false
        }else if index == 4 {
            addAgendaButton.setImage(UIImage(), for: .disabled)
            deleteAgendaButton.setImage(UIImage(named: "ic_create a meeting_agenda delete"), for: .normal)
            addAgendaButtonWidth.constant = 0
            addAgendaButton.isEnabled = false
        }else {
            deleteAgendaButtonWidth.constant = 46
            addAgendaButtonWidth.constant = 46
            addAgendaButton.isEnabled = true
            deleteAgendaButton.isEnabled = true
            addAgendaButton.setImage(UIImage(named: "ic_create a meeting_agenda plus"), for: .normal)
            deleteAgendaButton.setImage(UIImage(named: "ic_create a meeting_agenda delete"), for: .normal)
        }
    }
    
    private func addTapGesture() {
        let tapper = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tapper)
        
        addAgendaButton.rx.tap.subscribe(onNext: { _ in
            if self.meetingAgendaCreationVM.addAgenda() {
                self.agendaSelectBarCollectionView.reloadData()
            }
            
        }).disposed(by: disposeBag)
        deleteAgendaButton.rx.tap.subscribe(onNext: { _ in
            if self.meetingAgendaCreationVM.deleteAgenda() {
                self.agendaSelectBarCollectionView.reloadData()
            }
        }).disposed(by: disposeBag)
        
        addIssueButton.rx.tap.subscribe(onNext :{ _ in
            self.meetingAgendaCreationVM.addIssue()
        }).disposed(by: disposeBag)
        
        addDocumentButton.rx.tap.subscribe(onNext: {
            self.meetingAgendaCreationVM.addDocument()
        }).disposed(by: disposeBag)
        
    }
    
    func saveContent() {
        agendaTitleTextField.rx.text.subscribe(onNext: {
            self.meetingAgendaCreationVM.saveAgendaTitle(title: $0 ?? "")
        }).disposed(by: disposeBag)
    }
    
    func setAgendaContent(data:Agenda) {
        agendaTitleTextField.text = data.title
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
