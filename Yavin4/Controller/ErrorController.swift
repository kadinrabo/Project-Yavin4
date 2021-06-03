//
//  ErrorController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/18/21.
//

import UIKit


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class ErrorController: UIViewController {
    
    @IBOutlet var errorTextLabel: UILabel!  // Outlet for setting text
    var errorText: String = ""  // For setting error text anywhere in app bundle.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure View
        title = "Fatal Error"
        errorTextLabel.text = errorText
        navigationController?.navigationBar.isHidden = true
    }
}
