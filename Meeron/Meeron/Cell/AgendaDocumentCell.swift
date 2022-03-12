//
//  AgendaDocumentCell.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/03.
//

import Foundation
import UIKit

class AgendaDocumentCell:UITableViewCell {
    @IBOutlet weak var documentLabel: UILabel!
    
    var documentCellIndex = 0
    var meetingAgendaCreationVM:MeetingAgendaCreationViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(name:String, index:Int, vm:MeetingAgendaCreationViewModel) {
        documentLabel.text = name
        documentCellIndex = index
        meetingAgendaCreationVM = vm
    }
    @IBAction func deleteDocument(_ sender: Any) {
        self.meetingAgendaCreationVM?.deleteDocument(index: documentCellIndex)
    }
    
}


