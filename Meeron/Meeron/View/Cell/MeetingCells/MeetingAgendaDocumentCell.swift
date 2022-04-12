//
//  MeetingAgendaDocumentCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/31.
//

import Foundation
import UIKit

protocol MeetingAgendaDocumentCellProtocol {
    func showDocument(url:String, fileName:String)
}

class MeetingAgendaDocumentCell:UITableViewCell {
    
    @IBOutlet weak var documentLabel:UILabel!
    
    var documentUrl:String!
    
    var delegate:MeetingAgendaDocumentCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTapper()
    }
    
    func addTapper() {
        documentLabel.isUserInteractionEnabled = true
        let documentTapper = UITapGestureRecognizer()
        documentTapper.addTarget(self, action: #selector(showDocument))
        documentLabel.addGestureRecognizer(documentTapper)
    }
    
    @objc func showDocument() {
        guard let fileName = documentLabel.text else {return}
        delegate?.showDocument(url: documentUrl, fileName: fileName)
    }
}
