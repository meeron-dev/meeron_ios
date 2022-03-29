//
//  DateCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/23.
//

import Foundation
import UIKit

class CalendarDateCell:UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var dateString:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(data:MeetingDate?, selectedDate:String) {
        guard let data = data else {
            self.dateLabel.text = ""
            return
        }
        
        dateString = data.date
        dateLabel.text = data.date.getDay()
        print(data.date, selectedDate)
        if data.date == selectedDate {
            dateLabel.textColor = .mrBlue
            dateLabel.font = UIFont(name: FontNameConstant.bold, size: 17)
        }else {
            dateLabel.textColor = .darkGray
            dateLabel.font = UIFont(name: FontNameConstant.regular, size: 15)
        }
        
        
        if data.hasMeeting {
            meetingInfoCircleView.backgroundColor = .mrBlue
        }else {
            meetingInfoCircleView.backgroundColor = nil
        }
        
    }
}
