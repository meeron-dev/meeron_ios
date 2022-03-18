//
//  IntroductionCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/18.
//

import Foundation
import UIKit


class IntroductionCell:UICollectionViewCell {
    
    
    @IBOutlet weak var title1Label: UILabel!
    @IBOutlet weak var title2Label: UILabel!
    @IBOutlet weak var title3Label: UILabel!
    @IBOutlet weak var title4Label: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var description1Label: UILabel!
    @IBOutlet weak var description2Label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(data:Introduction) {
        title1Label.text = data.title1
        title2Label.text = data.title2
        title3Label.text = data.title3
        title4Label.text = data.title4
        subTitleLabel.text = data.subTitle
        description1Label.text = data.description1
        description2Label.text = data.description2
        imageView.image = UIImage(named: data.imageName)
    }
}
