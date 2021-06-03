//
//  SearchController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/18/21.
//

import UIKit


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class SearchController: UICollectionViewController, UISearchResultsUpdating { // Adopts search protocol
    
    var sections = [Section]()
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var searchController = UISearchController(searchResultsController: nil) // Instantiates a search controller with no view controller. Because it will be embedded in the navigation bar
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure View
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureHierarchy()
        createDataSource()
        
        // Network Service
        sections = NetworkService.SearchSections
        if sections.isEmpty {
            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [18]")
            present(ac, animated: true)
            return
        }
        reloadSearchResults(with: sections, animatingDifferences: false)  // Reload search results
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
            self.navigationController?.pushViewController(vc, animated: true)
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
}
