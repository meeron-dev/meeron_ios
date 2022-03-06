//
//  TimeSelectViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/03.
//

import Foundation
import UIKit

class TeamSelectViewController:UIViewController {
    
    @IBOutlet weak var teamTableView: UITableView!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        teamTableView.dataSource = self
        teamTableView.delegate = self
    }
    
    private func configureUI() {
        doneButton.addShadow()
        closeButton.addShadow()
    }
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TeamSelectViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingTeamSelectCell") as! MeetingTeamSelectCell
        return cell
    }
    
    
}
