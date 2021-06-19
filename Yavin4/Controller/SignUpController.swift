//
//  SignUpController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/23/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class SignUpController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet var dssTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure View
        title = "Sign Up"
        navigationItem.backButtonTitle = ""
        Helper.styleTextField(emailTextField, width: 35)
        Helper.styleTextField(passwordTextField, width: 62)
        Helper.styleTextField(dssTextField, width: 125)
        Helper.styleFilledButton(signupButton)
    }
}

// ######################################################
//MARK: VIEW DELEGATE METHOD(S)
// ######################################################

extension SignUpController {
    
    func transitionToHome() {  // Transitions to home page and makes it the root window
        let tabBarController = storyboard?.instantiateViewController(identifier: "TabHome") as? UITabBarController
        view.window?.rootViewController = tabBarController
        view.window?.makeKeyAndVisible()
    }
}

// ######################################################
//MARK: BUTTON DELEGATE METHOD(S)
// ######################################################

extension SignUpController {
    
    @IBAction func signupTapped(_ sender: Any) {
        let error = validateFields()  // Checks all fields
        if error != nil {  // Shows an error if validation methods fail
            let ac = Helper.createAlert(title: "Error", message: error)
            self.present(ac, animated: true)
        } else {  // Instantiates text field text in properties and creates a user document
            let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let dss = Helper.integer(from: dssTextField)  // Ensures days since surgery is a number. Else, 0
            Auth.auth().createUser(withEmail: email!, password: password!) { result, err in  // Create user
                if err != nil {
                    let ac = Helper.createAlert(title: "Error", message: err?.localizedDescription)
                    self.present(ac, animated: true)
                    return
                } else {  // Set user document data with empty saved, identifiers array and dss
                    Firestore.firestore().collection("yavin4-users").document(Auth.auth().currentUser!.uid).setData([
                        "saved":[],
                        "identifiers":[],
                        "dss":dss,
                        "paid":false
                    ]) { error in  // Catches any possible errors. Not likely this block is reached
                        if error != nil {
                            let ac = Helper.createAlert(title: "Error", message: error?.localizedDescription)
                            self.present(ac, animated: true)
                            return
                        }
                    }
                    self.transitionToHome()  // Executed when user and document created
                }
            }
        }
    }
}

// ######################################################
//MARK: VALIDATION DELEGATE METHOD(S)
// ######################################################

extension SignUpController {

    func validateFields() -> String? {  // Validates the fields, returns text if any check fails
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || dssTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill out all fields"
        }
        if Helper.integer(from: dssTextField) == 0 {
            return "Please enter days since surgery as a number. (e.g. 45)"
        }
        if Helper.isPasswordValid(passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) == false {
            return "Password must be at least 8 characters and contain a special character and a number."
        }
        return nil
    }
}
