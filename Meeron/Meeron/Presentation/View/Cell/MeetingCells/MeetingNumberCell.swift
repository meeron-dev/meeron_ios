//
//  MeetingNumberCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/29.
//

import UIKit

class MeetingNumberCell: UICollectionViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(number:Int, nowNumber:Int) {
        numberLabel.text = "\(number)"
        if number != nowNumber {
            numberLabel.font = .systemFont(ofSize: 24, weight: .thin)
            numberLabel.textColor = .darkGray
        }else {
            numberLabel.font = .systemFont(ofSize: 24, weight: .bold)
            numberLabel.textColor = .mrDarkBlue
        }
    }
    
    

}
