//
//  StageController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/13/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class StageController: UICollectionViewController {
    
    var sections = [Section]()
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!  // Data source for configured cells
    
    var stageIdentifier: String!  // Used to filter out sections not selected

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure View
        navigationController?.navigationBar.prefersLargeTitles = true
        configureHierarchy()  // Configure layout
        createDataSource()  // Configure cells
        
        // Network Service
        networkService()
    }
}

// ####################################################
//MARK: VIEW DELEGATE METHOD(S)
// ####################################################

extension StageController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {  // Item is selected
        guard let identifier = dataSource?.itemIdentifier(for: indexPath)?.identifier else {  // Gets the essential identifier of the item
            let ac = Helper.createAlert(title: "Error", message: "Error locating requested category identifier. [8]")
            present(ac, animated: true)
            return
        }
        guard let title = dataSource?.itemIdentifier(for: indexPath)?.title else {  // Gets the essential title of the item
            let ac = Helper.createAlert(title: "Error", message: "Error locating requested category. [9]")
            present(ac, animated: true)
            return
        }
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Workout") as? WorkoutController {  // Show workout view controller by passing a workout identifier as a filter and a title
            vc.workoutIdentifier = identifier
            vc.title = title
            vc.downButton.tintColor = UIColor.label
            self.collectionView.deselectItem(at: indexPath, animated: true)
            self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        } else {  // Block ran if the instantiation fails
            let ac = Helper.createAlert(title: "Error", message: "Problem displaying requested data. [10]")
            present(ac, animated: true)
            return
        }
    }
}

// ####################################################
//MARK: DATA DELEGATE METHOD(S)
// ####################################################

extension StageController {
    
    func reloadData(with sections: [Section]) {  // Upload changes to the snapshot with sections
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()  // Empty data source snapshot for sections
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.data!, toSection: section)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
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
                        self.sections = NetworkService.getFreeStageSections(with: self.stageIdentifier)!
                        if self.sections.isEmpty {
                            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [6]")
                            self.present(ac, animated: true)
                            return
                        }
                        self.reloadData(with: self.sections)
                    } else if data.paid {
                        self.sections = NetworkService.getStageSections(with: self.stageIdentifier)!
                        if self.sections.isEmpty {
                            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [7]")
                            self.present(ac, animated: true)
                            return
                        }
                        self.reloadData(with: self.sections)
                    } else {
                        if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                            vc.errorText = "viewDidLoad() @ StageController.swift in else block of success case"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            case .failure(_):
                if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                    vc.errorText = "viewDidLoad() @ StageController.swift in .failure case block"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
