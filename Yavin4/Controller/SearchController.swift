//
//  SearchController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/18/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class SearchController: UICollectionViewController, UISearchResultsUpdating { // Adopts search protocol
    
    @IBOutlet var favoriteButton: UIBarButtonItem!
    var sections = [Section]()
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var searchController = UISearchController(searchResultsController: nil) // Instantiates a search controller with no view controller. Because it will be embedded in the navigation bar
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure View
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.favoriteButton.tintColor = UIColor.clear
        self.favoriteButton.isEnabled = false
        configureHierarchy()
        createDataSource()
        updateNavBarButtons()
        
        // Network Service
        networkService()
    }
}

// ######################################################
//MARK: VIEW DELEGATE METHOD(S)
// ######################################################

extension SearchController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let identifier = dataSource?.itemIdentifier(for: indexPath)?.identifier else {  // Get essential identifier item
            if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                vc.errorText = "didSelectItem() @ SearchController.swift in identifier guard block"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        guard let title = dataSource?.itemIdentifier(for: indexPath)?.title else {  // Get essential title item
            if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                vc.errorText = "didSelectItem() @ SearchController.swift in title guard block"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Workout") as? WorkoutController {
            vc.workoutIdentifier = identifier
            vc.title = title
            vc.downButton.tintColor = UIColor.label
            self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            self.collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                vc.errorText = "didSelectItem() @ SearchController.swift in else block of WorkoutController instantiation"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
    }
}

// ######################################################
//MARK: BUTTON DELEGATE METHOD(S)
// ######################################################

extension SearchController {
    
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
                    } else if data!.paid {
                        self.favoriteButton.tintColor = UIColor.label
                        self.favoriteButton.isEnabled = true
                    }
                } else {
                    if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                        vc.errorText = "updateNavBarButtons() @ SearchController.swift in else data nil block"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            case .failure(_):
                if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                    vc.errorText = "updateNavBarButtons() @ SearchController.swift in failure case block"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

// ######################################################
//MARK: DATA DELEGATE METHOD(S)
// ######################################################

extension SearchController {
    
    func reloadSearchResults(with sections: [Section], animatingDifferences: Bool = true) {  // Identical to reloadData() but with varied animation Bool
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.data!, toSection: section)
        }
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func updateSearchResults(for searchController: UISearchController) {  // Essential method to conform to UISearchResultsUpdating. It reloads data source by calling reloadSearchResults() with or without new data
        var filtered = sections  // Creates a copy of all sections
        let items = sections[0].data!
        if searchController.searchBar.text!.isEmpty {  // Makes it so all the old search results pop up when the user deletes their text
            reloadSearchResults(with: filtered, animatingDifferences: true)
        } else {  // Removes all data from the sections and adds any items that match the search
            filtered[0].data?.removeAll()
            for i in 0..<items.count {
                if let title = items[i].title?.lowercased() {
                    if title.contains(searchController.searchBar.text!.lowercased()) {
                        filtered[0].data?.append(items[i])
                    }
                }
            }
            reloadSearchResults(with: filtered, animatingDifferences: false)
        }
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
                        self.sections = NetworkService.FreeControllers.SearchController
                        if self.sections.isEmpty {
                            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [8]")
                            self.present(ac, animated: true)
                            return
                        }
                        self.reloadSearchResults(with: self.sections, animatingDifferences: false)
                    } else if data.paid {
                        self.sections = NetworkService.SearchSections
                        if self.sections.isEmpty {
                            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [9]")
                            self.present(ac, animated: true)
                            return
                        }
                        self.reloadSearchResults(with: self.sections, animatingDifferences: false)
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
