//
//  SettingsController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/16/21.
//

import UIKit
import Firebase


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class SettingsController: UICollectionViewController {
    
    var sections = [Section]()
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! // Data source for configured cells
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>() // Data source snapshot
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure View
        self.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureHierarchy()
        createDataSource()

        // Network Service
        sections = NetworkService.SettingsSections
        if sections.isEmpty {
            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [12]")
            present(ac, animated: true)
            return
        }
        reloadData()
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
}
