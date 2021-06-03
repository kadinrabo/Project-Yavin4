//
//  ForgotPasswordController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/24/21.
//

import UIKit
import Firebase


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class ForgotPasswordController: UIViewController {
    
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure View
        navigationController?.navigationBar.isHidden = true
        navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.isHidden = false
        Helper.styleFilledButton(sendButton)
    }
}


// ######################################################
//MARK: BUTTON DELEGATE METHOD(S)
// ######################################################

extension ForgotPasswordController {
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  // Gets user email from text field
        Auth.auth().sendPasswordReset(withEmail: email!) { error in  // Send email password reset
            if error != nil {
                let ac = Helper.createAlert(title: "Error", message: error?.localizedDescription)
                self.present(ac, animated: true)
                return
            } else {
                let ac = Helper.createAlert(title: "Success!", message: "Email password reset sent to \(email!)")
                self.present(ac, animated: true)
            }
        }
    }
}
