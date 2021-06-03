//
//  StageController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/13/21.
//

import UIKit


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class StageController: UICollectionViewController {
    
    var sections = [Section]()
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!  // Data source for configured cells
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()  // Empty data source snapshot for sections
    var stageIdentifier: String!  // Used to filter out sections not selected

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure View
        navigationController?.navigationBar.prefersLargeTitles = true
        configureHierarchy()  // Configure layout
        createDataSource()  // Configure cells
        
        // Network Service
        guard let sections = NetworkService.getStageSections(with: stageIdentifier) else {  // Get available sections with the stage identifier passed from StagesController
            if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                vc.errorText = "guard let sections block @ StageController.swift"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        
        if sections.isEmpty {
            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [7]")
            present(ac, animated: true)
            return
        }
        reloadData(with: sections)
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
            self.navigationController?.pushViewController(vc, animated: true)
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
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.data!, toSection: section)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
