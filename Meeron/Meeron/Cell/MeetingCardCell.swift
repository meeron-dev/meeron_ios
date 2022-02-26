//
//  MeetingCardCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/22.
//

import Foundation
import UIKit

class MeetingCardCell:UICollectionViewCell {
    
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
    
}
