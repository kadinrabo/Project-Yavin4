//
//  LoginController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/23/21.
//

import UIKit
import Firebase


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class LoginController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure View
        title = "Log In"
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = UIColor.label
        Helper.styleTextField(emailTextField, width: 35)
        Helper.styleTextField(passwordTextField, width: 62)
        Helper.styleFilledButton(loginButton)
    }
}

// ######################################################
//MARK: BUTTON DELEGATE METHOD(S)
// ######################################################

extension LoginController {
    
    @IBAction func loginTapped(_ sender: Any) {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: email!, password: password!) { result, error in  // Signs user in, transitions to home, and makes home root view controller
            if error != nil {
                let ac = Helper.createAlert(title: "Error", message: error!.localizedDescription)
                self.present(ac, animated: true)
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabHome") as! UITabBarController
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }
    }
}
