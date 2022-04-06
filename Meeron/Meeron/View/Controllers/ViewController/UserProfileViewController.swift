//
//  UserProfileViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/31.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setProfileData(data: WorkspaceUser, teamName:String) {
        //nameLabel.text = data.
        nicknameLabel.text = data.nickname
        positionLabel.text = data.position
        phoneNumberLabel.text = data.phone
        emailLabel.text = data.email
        teamLabel.text = teamName
    }
    
}
