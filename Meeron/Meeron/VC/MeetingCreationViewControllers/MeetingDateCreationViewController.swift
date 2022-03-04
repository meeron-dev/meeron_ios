//
//  MeetingDateCreationViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/28.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class MeetingDateCreationViewController:UIViewController {
    
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var meetingCreationData = MeetingCreation()
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupDateLabelTap()
        
    }
    
    private func configureUI() {
        nextButton.addShadow()
        self.navigationItem.titleView = UILabel.meetingCreationNavigationItemTitleLabel
        setupDate()
    }
    
    func setupDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateLabel.text = dateFormatter.string(from: Date())
    }
    
    func setupDateLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(showDatePickerView))
        dateLabel.isUserInteractionEnabled = true
        dateLabel.addGestureRecognizer(labelTap)
    }
    
    @objc func showDatePickerView() {
        let datePickerVC = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
        datePickerVC.modalPresentationStyle = .custom
        datePickerVC.transitioningDelegate = self
        self.present(datePickerVC, animated: true, completion: nil)
        
        datePickerVC.datePicker.datePickerMode = .date
        datePickerVC.dateSubject.subscribe(onNext: {
            self.setDate(date: $0)
        }).disposed(by: disposeBag)
    }
    
    func setDate(date:Date) {
        meetingCreationData.date = date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 25)
        dateLabel.textColor = .black
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    @IBAction func exitMeetingCreation(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let meetingTimeCreationVC = segue.destination as? MeetingTimeCreationViewController else { return }
        meetingTimeCreationVC.meetingCreationData = meetingCreationData
    }*/
    
}

extension MeetingDateCreationViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DatePickerModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
