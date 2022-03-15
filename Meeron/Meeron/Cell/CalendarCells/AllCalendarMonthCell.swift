//
//  AllCalendarMonthCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/15.
//

import Foundation
import UIKit

class AllCalendarMonthCell:UICollectionViewCell {
    
    @IBOutlet weak var monthLabel:UILabel!
    @IBOutlet weak var meetingCountLabel:UILabel!
    @IBOutlet weak var meetingInfoDotView:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        meetingInfoDotView.layer.cornerRadius = meetingInfoDotView.frame.height/2
    }
    
    func setData(data:MonthMeetingCount, nowMonth:String) {
        print(data, nowMonth)
        if String(data.month) == nowMonth {
            monthLabel.textColor = .mrBlue
            meetingCountLabel.textColor = .grayBlue
            monthLabel.font = UIFont(name: FontNameConstant.bold, size: 18)
            meetingCountLabel.font = UIFont(name:FontNameConstant.medium, size: 12)
        }else {
            monthLabel.textColor = .textBalck
            meetingCountLabel.textColor = .darkGray
            monthLabel.font = UIFont(name: FontNameConstant.semiBold, size: 18)
            meetingCountLabel.font = UIFont(name:FontNameConstant.medium, size: 12)
        }
        
        monthLabel.text = "\(data.month)월"
        meetingCountLabel.text = "\(data.count)개의 회의"
    }
}
