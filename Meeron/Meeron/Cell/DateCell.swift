//
//  DateCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/23.
//

import Foundation
import UIKit

class DateCell:UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var meetingInfoCircleView: UIView!
    
    
    var dateString:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        meetingInfoCircleView.layer.cornerRadius = meetingInfoCircleView.frame.height/2
    }
    
    func setData(data:MeetingDate?) {
        guard let data = data else {
            meetingInfoCircleView.backgroundColor = nil
            self.dateLabel.text = ""
            return
        }
        
        dateString = data.date
        dateLabel.text = data.date.getDay()
        
        if data.date == Date().toSlashDateString() {
            dateLabel.textColor = .mrBlue
            dateLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        }else {
            dateLabel.textColor = .darkGray
            dateLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        }
        
        
        if data.hasMeeting {
            meetingInfoCircleView.backgroundColor = .mrBlue
        }else {
            meetingInfoCircleView.backgroundColor = nil
        }
        
    }
}
