//
//  StagesController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/13/21.
//

import UIKit
import SafariServices
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class StagesController: UICollectionViewController {
    
    @IBOutlet var favoriteButton: UIBarButtonItem!
    var sections = [Section]()
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!  // Data source for configured cells
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure View
        title = "Stages"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.favoriteButton.tintColor = UIColor.clear
        self.favoriteButton.isEnabled = false
        configureHierarchy()  // Configure layout
        createDataSource()  // Configure sections as reusable cells
        updateNavBarButtons()
        
        // Network Service
        networkService()
    }
}

// ######################################################
//MARK: VIEW DELEGATE METHOD(S)
// ######################################################

extension StagesController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {  // For selected items
        
        guard let itemType = dataSource?.itemIdentifier(for: indexPath)?.description else {  // The item's itemType is an essential. Shows error if nil.
            let ac = Helper.createAlert(title: "Error", message: "Error performing request. [5]")
            present(ac, animated: true)
            return
        }
        
        let identifier = dataSource?.itemIdentifier(for: indexPath)?.identifier
        let title = dataSource?.itemIdentifier(for: indexPath)?.title
        let urlString = dataSource?.itemIdentifier(for: indexPath)?.url
        
        if itemType == "Stage" && identifier != nil && title != nil, let vc = self.storyboard?.instantiateViewController(withIdentifier: "Stage") as? StageController {  // Shows stage view if the item contains identifier and a title
            vc.stageIdentifier = identifier
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        } else if itemType == "Workout" && identifier != nil && title != nil, let vc = self.storyboard?.instantiateViewController(withIdentifier: "Workout") as? WorkoutController {  // Shows workout view if the item contains identifier and a title
            vc.workoutIdentifier = identifier
            vc.title = title
            vc.downButton.tintColor = UIColor.label
            self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        } else if itemType == "Article" && urlString != nil {  // Shows safari article view
            let url = URL(string: urlString!)
            let safariViewController = SFSafariViewController(url: url!)
            present(safariViewController, animated: true, completion: nil)
        } else {
            let ac = Helper.createAlert(title: "Error", message: "Error performing request. [6]")
            present(ac, animated: true)
            return
        }
    }
}

// ######################################################
//MARK: BUTTON DELEGATE METHOD(S)
// ######################################################

extension StagesController {
    
    func updateNavBarButtons() {
        let userRef = Firestore.firestore().collection("yavin4-users").document(Auth.auth().currentUser!.uid)
        
        userRef.getDocument { document, error in
            let result = Result {
              try document?.data(as: User.self)
            }
            switch result {
            case .success(let data):
                if data != nil {
                    if !data!.paid {
                        self.favoriteButton.tintColor = UIColor.clear
                        self.favoriteButton.isEnabled = false
                    } else if data!.paid {
                        self.favoriteButton.tintColor = UIColor.label
                        self.favoriteButton.isEnabled = true
                    }
                } else {
                    if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                        vc.errorText = "updateNavBarButtons() @ StagesController.swift in else data nil block"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            case .failure(_):
                if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                    vc.errorText = "updateNavBarButtons() @ StagesController.swift in failure case block"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

// ######################################################
//MARK: DATA DELEGATE
// ######################################################

extension StagesController {
    
    func reloadData() {  // Apply sections and items to the snapshot and then to the datasource
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()  // Empty data source snapshot
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
                        self.sections = NetworkService.FreeControllers.StagesController
                        if self.sections.isEmpty {
                            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [1]")
                            self.present(ac, animated: true)
                            return
                        }
                        self.reloadData()
                    } else if data.paid {
                        self.sections = NetworkService.StagesSections
                        if self.sections.isEmpty {
                            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [2]")
                            self.present(ac, animated: true)
                            return
                        }
                        self.reloadData()
                    } else {
                        if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                            vc.errorText = "viewDidLoad() @ StagesController.swift in else block of success case"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            case .failure(_):
                if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                    vc.errorText = "viewDidLoad() @ StagesController.swift in .failure case block"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
