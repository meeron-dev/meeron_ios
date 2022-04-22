//
//  AllCalendarYearCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/15.
//

import Foundation
import UIKit

class AllCalendarYearCell:UITableViewCell {
    
    @IBOutlet weak var yearLabel:UILabel!
    @IBOutlet weak var meetingCountLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(data: YearMeetingCount, nowYear:String) {
        
        if String(data.year) == nowYear {
            yearLabel.textColor = .mrBlue
            meetingCountLabel.textColor = .textBalck
            yearLabel.font = UIFont(name: FontNameConstant.bold, size: 18)
            meetingCountLabel.font = UIFont(name:FontNameConstant.medium, size: 12)
        }else {
            yearLabel.textColor = .textBalck
            meetingCountLabel.textColor = .darkGray
            yearLabel.font = UIFont(name: FontNameConstant.medium, size: 18)
            meetingCountLabel.font = UIFont(name:FontNameConstant.medium, size: 12)
        }
        yearLabel.text = String(data.year)
        meetingCountLabel.text = "\(data.count)개의 회의"
    }
}
