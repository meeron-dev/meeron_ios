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
    
    
    @IBOutlet weak var addAgendaButton:UIButton!
    @IBOutlet weak var deleteAgendaButton:UIButton!
    @IBOutlet weak var addAgendaButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var deleteAgendaButtonWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var agendaSelectBarCollectionView: UICollectionView!
    
    @IBOutlet weak var addIssueButton: UIButton!
    @IBOutlet weak var addDocumentButton: UIButton!
    //var nowAgendaIndex = 1
    
    let meetingAgendaCreationVM = MeetingAgendaCreationViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        agendaSelectBarCollectionView.delegate = self
        agendaSelectBarCollectionView.dataSource = self
        agendaSelectBarCollectionView.register(UINib(nibName: "AgendaSelectBarCell", bundle: nil), forCellWithReuseIdentifier: "AgendaSelectBarCell")
        
        
        
        configureUI()
        setupCollectionView()
        
    }
    
    private func setupCollectionView() {
        
        setupCollectionViewLayout()
        
        /*meetingAgendaCreationVM.agendasSubject.bind(to: agendaSelectBarCollectionView.rx.items) { collectionView, row, element in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AgendaSelectBarCell", for: indexPath) as! AgendaSelectBarCell
            //cell.agendaNumberLabel.text = String(row+1)
            return cell
        }.disposed(by: disposeBag)
        
        agendaSelectBarCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print(indexPath)
                //self.meetingAgendaCreationVM.nowAgendaIndex = indexPath.row+1
            }).disposed(by: disposeBag)
        */
        //meetingAgendaCreationVM.initAgendas()
        
    }
    
    private func setupCollectionViewLayout() {
        let agendaSelectBarCollectionViewlayout = UICollectionViewFlowLayout()
        agendaSelectBarCollectionViewlayout.itemSize = CGSize(width: 44, height: 44)
        agendaSelectBarCollectionViewlayout.scrollDirection = .horizontal
        agendaSelectBarCollectionViewlayout.minimumLineSpacing = 0
        agendaSelectBarCollectionViewlayout.minimumInteritemSpacing = 0
        
        agendaSelectBarCollectionView.collectionViewLayout = agendaSelectBarCollectionViewlayout
        //agendaSelectBarCollectionView.canCancelContentTouches = false
    }
    
    private func configureUI() {
        self.navigationItem.titleView = UILabel.meetingCreationNavigationItemTitleLabel
        
        prevButton.addShadow()
        nextButton.addShadow()
        
        addTapGesture()
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
        
    }
    
    func setAgendaContent() {
        print("아젠다 정보 바뀜")
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
}


extension MeetingAgendaCreationViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension MeetingAgendaCreationViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AgendaSelectBarCell", for: indexPath) as! AgendaSelectBarCell
        return cell
    }
    
    
}
