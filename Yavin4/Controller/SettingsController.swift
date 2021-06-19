//
//  SettingsController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/16/21.
//

import UIKit
import Firebase
import StoreKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class SettingsController: UICollectionViewController {
    
    var sections = [Section]()
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! // Data source for configured cells
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>() // Data source snapshot
    var accountStatusText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure View
        self.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureHierarchy()
        createDataSource()

        // Network Service and Set Account Status Text
        networkService()
    }
}

// ######################################################
//MARK: VIEW DELEGATE METHOD(S)
// ######################################################

extension SettingsController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { // Item selected
        
        guard let settingTitle = dataSource?.itemIdentifier(for: indexPath)?.title else { // Get item title, show error if fail. Essential data.
            let ac = Helper.createAlert(title: "Error", message: "Error performing settings request. [14]")
            present(ac, animated: true)
            return
        }
        
        if settingTitle == "Change Password" {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Forgot") as? ForgotPasswordController {
                vc.navigationController?.navigationBar.isHidden = true
                navigationController?.pushViewController(vc, animated: true)
            }
        } else if settingTitle == "Email Address" {
            let ac = Helper.createAlert(title: "Account Email", message: Auth.auth().currentUser?.email) // Show user email
            collectionView.deselectItem(at: indexPath, animated: true)
            self.present(ac, animated: true)
        } else if settingTitle == "Account Status" {
            let ac = Helper.createAlert(title: "Account Status", message: accountStatusText)
            self.collectionView.deselectItem(at: indexPath, animated: true)
            self.present(ac, animated: true)
        } else {
            let ac = Helper.createAlert(title: "Error", message: "Error performing settings request. [16]")
            present(ac, animated: true)
            return
        }
    }
}

// ######################################################
//MARK: BUTTON DELEGATE METHOD(S)
// ######################################################

extension SettingsController {
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut() // Attempt a sign out
            exit(1)
        } catch let signoutError { // Block catches any sign out errors
            let ac = Helper.createAlert(title: "Network Error", message: signoutError.localizedDescription)
            self.present(ac, animated: true)
            return
        }
    }
    
    @IBAction func downButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// ######################################################
//MARK: DATA DELEGATE METHOD(S)
// ######################################################

extension SettingsController {
    
    func reloadData() { // Upload sections to data source
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.data!, toSection: section)
        }
        dataSource?.apply(snapshot)
    }
    
    func networkService() {
        Firestore.firestore().collection("yavin4-users").document(Auth.auth().currentUser!.uid).addSnapshotListener { document, error in
            let result = Result {
                try document?.data(as: User.self)
            }
            switch result {
            case .success(let data):
                if let data = data {
                    if !data.paid {
                        self.sections = NetworkService.FreeControllers.SettingsController
                        self.accountStatusText = "Free"
                        if self.sections.isEmpty {
                            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [4]")
                            self.present(ac, animated: true)
                            return
                        }
                        self.reloadData()
                    } else if data.paid {
                        self.sections = NetworkService.SettingsSections
                        self.accountStatusText = "Paid"
                        if self.sections.isEmpty {
                            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [5]")
                            self.present(ac, animated: true)
                            return
                        }
                        self.reloadData()
                    } else {
                        if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                            vc.errorText = "viewDidLoad() @ SettingsController.swift in else block of success case"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            case .failure(_):
                if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                    vc.errorText = "viewDidLoad() @ SettingsController.swift in .failure case block"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
