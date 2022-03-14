//
//  CalendarMeetingCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/14.
//

import Foundation
import UIKit

class CalendarMeetingCell:UITableViewCell {
    
    @IBOutlet weak var meetingNumberView:UIView!
    @IBOutlet weak var meetingNumberLabel:UILabel!
    @IBOutlet weak var meetingNameLabel: UILabel!
    @IBOutlet weak var meetingTimeLabel:UILabel!
    
    var meetingId:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        meetingNumberView.layer.cornerRadius = meetingNumberView.frame.height/2
    }
    
    func setData(data:CalendarMeeting, number:Int) {
        meetingNameLabel.text = data.meetingName
        meetingTimeLabel.text = data.startTime + " ~ " + data.endTime
        meetingNumberLabel.text = String(number)
    }
}
