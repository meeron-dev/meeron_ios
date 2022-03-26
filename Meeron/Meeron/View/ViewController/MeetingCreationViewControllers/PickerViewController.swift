//
//  PickerViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/01.
//

import Foundation
import UIKit
import RxSwift
class DatePickerViewController:UIViewController{
    @IBOutlet weak var dateContentView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    
    let dateSubject = PublishSubject<Date>()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func done(_ sender: Any) {
        dateSubject.onNext(datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
    
}
