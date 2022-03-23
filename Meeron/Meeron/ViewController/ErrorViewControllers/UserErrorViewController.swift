//
//  UserErrorViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/22.
//

import UIKit

class UserErrorViewController: UIViewController {
    
    var userSignUpState:UserSignUpState!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func goNextView(_ sender: Any) {
        let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if userSignUpState == .login {
            let loginVC = mainStroyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        }else if userSignUpState == .terms {
            let termsVC = mainStroyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            termsVC.modalPresentationStyle = .fullScreen
            present(termsVC, animated: true, completion: nil)
            
        }else if userSignUpState == .userName {
            let userNameVC = mainStroyboard.instantiateViewController(withIdentifier: "UserNameViewController") as! UserNameViewController
            userNameVC.modalPresentationStyle = .fullScreen
            present(userNameVC, animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
