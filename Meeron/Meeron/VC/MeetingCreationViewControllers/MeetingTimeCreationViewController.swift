//
//  MeetingTimeCreationViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/02.
//

import Foundation
import UIKit
import RxSwift

class MeetingTimeCreationViewController:UIViewController {
    @IBOutlet weak var meetingDateLabel: UILabel!
    
    @IBOutlet weak var meetingStartTimeLabel: UILabel!
    @IBOutlet weak var meetingStartTimeALabel: UILabel!
    @IBOutlet weak var meetingEndTimeLabel: UILabel!
    @IBOutlet weak var meetingEndTimeALabel: UILabel!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var meetingCreationData:MeetingCreation!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addDateLabelTap()
    }
    
    private func configureUI() {
        self.navigationItem.titleView = UILabel.meetingCreationNavigationItemTitleLabel
        
        self.nextButton.addShadow()
        self.prevButton.addShadow()
        
        setupTime()
        setMeetingCreationData()
    }
    
    func setupTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:00"
        let now = Date()
        meetingStartTimeLabel.text = dateFormatter.string(from: now)
        meetingEndTimeLabel.text = dateFormatter.string(from: now)
        
        dateFormatter.dateFormat = "a"
        meetingStartTimeALabel.text = dateFormatter.string(from: now)
        meetingEndTimeALabel.text = dateFormatter.string(from: now)
    }
    
    func setMeetingCreationData() {
        meetingDateLabel.text = meetingCreationData.date.changeMeetingCreationDateToKoreanString()
    }
    
    func addDateLabelTap() {
        let meetingStartTimeLabelTap = UITapGestureRecognizer(target: self, action: #selector(showStartTimePickerView))
        meetingStartTimeLabel.isUserInteractionEnabled = true
        meetingStartTimeLabel.addGestureRecognizer(meetingStartTimeLabelTap)
        
        let meetingEndTimeLabelTap = UITapGestureRecognizer(target: self, action: #selector(showEndTimePickerView))
        meetingEndTimeLabel.isUserInteractionEnabled = true
        meetingEndTimeLabel.addGestureRecognizer(meetingEndTimeLabelTap)
    }
    
    @objc func showStartTimePickerView() {
        let datePickerVC = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
        datePickerVC.modalPresentationStyle = .custom
        datePickerVC.transitioningDelegate = self
        self.present(datePickerVC, animated: true, completion: nil)
        
        datePickerVC.datePicker.datePickerMode = .time
        datePickerVC.datePicker.locale = Locale(identifier: "ko-KR")
        datePickerVC.dateSubject.subscribe(onNext: {
            self.setStartTime(time: $0)
        }).disposed(by: disposeBag)
    }
    
    @objc func showEndTimePickerView() {
        let datePickerVC = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
        datePickerVC.modalPresentationStyle = .custom
        datePickerVC.transitioningDelegate = self
        self.present(datePickerVC, animated: true, completion: nil)
        
        datePickerVC.datePicker.datePickerMode = .time
        datePickerVC.datePicker.locale = Locale(identifier: "ko-KR")
        datePickerVC.dateSubject.subscribe(onNext: {
            self.setEndTime(time: $0)
        }).disposed(by: disposeBag)
    }
    
    func setStartTime(time:Date) {
        meetingCreationData.startTime = time
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm"
        meetingStartTimeLabel.text = dateFormatter.string(from: time)
        
        dateFormatter.dateFormat = "a"
        meetingStartTimeALabel.text = dateFormatter.string(from: time)
        
    }
    
    func setEndTime(time:Date) {
        meetingCreationData.endTime = time
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm"
        meetingEndTimeLabel.text = dateFormatter.string(from: time)
        
        dateFormatter.dateFormat = "a"
        meetingEndTimeALabel.text = dateFormatter.string(from: time)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let meetingBasicInfoCreationVC = segue.destination as? MeetingBaiscInfoCreationViewController else { return }
        meetingBasicInfoCreationVC.meetingBaiscInfoCreationVM.setMeetingCreationData(data: meetingCreationData)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func exitMeetingCreation(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension MeetingTimeCreationViewController:UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DatePickerModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
