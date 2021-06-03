//
//  StagesController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/13/21.
//

import UIKit
import SafariServices


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class StagesController: UICollectionViewController {
    
    var sections = [Section]()
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!  // Data source for configured cells
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()  // Empty data source snapshot
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure View
        configureHierarchy()  // Configure layout
        createDataSource()  // Configure sections as reusable cells
        title = "Stages"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Network Service
        sections = NetworkService.StagesSections
        if sections.isEmpty {
            let ac = Helper.createAlert(title: "Error", message: "Error getting sections @ StagesController.")
            present(ac, animated: true)
            return
        }
        reloadData()
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
//MARK: DATA DELEGATE
// ######################################################

extension StagesController {
    
    func reloadData() {  // Apply sections and items to the snapshot and then to the datasource
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.data!, toSection: section)
        }
        dataSource?.apply(snapshot)
    }
}
