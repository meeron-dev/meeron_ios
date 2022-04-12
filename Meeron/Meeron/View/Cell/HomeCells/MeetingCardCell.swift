//
//  MeetingCardCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/22.
//

import Foundation
import UIKit

class MeetingCardCell:UICollectionViewCell {
    
    @IBOutlet weak var meetingNameLabel: UILabel!
    @IBOutlet weak var meetingDateLabel: UILabel!
    @IBOutlet weak var meetingTimeLabel: UILabel!
    @IBOutlet weak var meetingTeamLabel: UILabel!
    @IBOutlet weak var meetingPurposeLabel: UILabel!
    
    @IBOutlet weak var meetingAgendaLabel: UILabel!
    
    @IBOutlet weak var attendsLabel:UILabel!
    @IBOutlet weak var absentsLabel:UILabel!
    @IBOutlet weak var unknownsLabel:UILabel!
    
    
    var meetingId:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayer()
    }
    
    func setupLayer() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4.65
        layer.shadowOffset = CGSize(width: 4.72, height: 5.65)
        
        contentView.layer.cornerRadius = 4.65
        contentView.layer.masksToBounds = true
    }
    
    func setData(data:TodayMeeting) {
        meetingDateLabel.text = data.meeting.startDate.toKoreanDateString()
        meetingNameLabel.text = data.meeting.meetingName
        meetingTeamLabel.text = data.team.teamName
        meetingTimeLabel.text = data.meeting.startTime + "~" + data.meeting.endTime
        meetingPurposeLabel.text = data.meeting.purpose
        
        attendsLabel.text = String(data.attendCount.attend)
        absentsLabel.text = String(data.attendCount.absent)
        unknownsLabel.text = String(data.attendCount.unknown)
        
        if data.agendas.count > 0{
            meetingAgendaLabel.text = data.agendas[0].agendaName
        }else {
            meetingAgendaLabel.text = ""
        }
        
        
        meetingId = data.meeting.meetingId
    }
}
