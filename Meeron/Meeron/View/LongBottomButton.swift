//
//  LongBottomButton.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/26.
//

import UIKit

class LongBottomButton: UIButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    func configureUI() {
        self.addShadow()
        self.backgroundColor = .buttonGray
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    convenience init() {
            self.init()
     
            self.addTarget(self, action: #selector(changeColor(_:)), for: .touchUpInside)
        }

    
    @objc func changeColor(_ sender: UIButton) {
           self.backgroundColor = .cyan
    }


}
