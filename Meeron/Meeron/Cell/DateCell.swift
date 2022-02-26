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
    }
    
    func setData(date:String?) {
        guard let date = date else {
            self.dateLabel.text = ""
            return
        }
        
        self.dateString = date
        dateLabel.text = date.getDay()
        
    }
}
