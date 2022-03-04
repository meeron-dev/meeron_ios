//
//  AgendaSelectBarCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/04.
//

import Foundation
import UIKit

class AgendaSelectBarCell:UICollectionViewCell {
    
    @IBOutlet weak var barIndexView: UIView!
    @IBOutlet weak var agendaNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(selectedIndex))
        //contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc func selectedIndex() {
        agendaNumber.textColor = .mrBlue
        print("선택")
    }
}
