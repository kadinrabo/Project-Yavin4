//
//  SavedController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/16/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class SavedController: UICollectionViewController {
    
    @IBOutlet var addWorkoutButton: UIBarButtonItem! // Workout outlet for button color
    var sections = [Section]()
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure View
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureHierarchy()
        createDataSource()
        
        // Network Service
        sections = NetworkService.SavedSections
        if sections.isEmpty {
            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [17]")
            present(ac, animated: true)
            return
        }
        populateSavedWorkouts() // Populates the entire view based on realtime database document
    }
}

// ######################################################
//MARK: VIEW DELEGATE METHOD(S)
// ######################################################

extension SavedController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let identifier = dataSource?.itemIdentifier(for: indexPath)?.identifier else { // Get essential item identifier
            if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                vc.errorText = "didSelectItem() @ SavedController.swift in identifier guard block"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        guard let title = dataSource?.itemIdentifier(for: indexPath)?.title else { // Get essential item title
            if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                vc.errorText = "didSelectItem() @ SavedController.swift in title guard block"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Workout") as? WorkoutController {
            vc.workoutIdentifier = identifier
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true) // Push the workout up from bottom
        } else {
            if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                vc.errorText = "didSelectItem() @ SavedController.swift in else block of WorkoutController instantiation"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
    }
}

// ######################################################
//MARK: BUTTON DELEGATE METHOD(S)
// ######################################################

extension SavedController {
    
    @IBAction func addWorkoutButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil) // Pushes saved controller down away
    }
}

// ######################################################
//MARK: DATA DELEGATE METHOD(S)
// ######################################################

extension SavedController {
    
    func populateSavedWorkouts() {
        Firestore.firestore().collection("yavin4-users").document(Auth.auth().currentUser!.uid).addSnapshotListener { document, error in // realtime listener for changes in the user's document
            let result = Result {
              try document?.data(as: User.self) // Convert user document to User object
            }
            switch result {
            case .success(let data):
                if let data = data { // If data isn't nil, reload the datasource with the new sections
                    self.snapshot.deleteAllItems()
                    self.snapshot.appendSections(self.sections)
                    for section in self.sections {
                        self.snapshot.appendItems(data.saved, toSection: section)
                    }
                    self.sections[0].data = data.saved
                    self.dataSource?.apply(self.snapshot, animatingDifferences: false)
                } else { // Block executed if data is nil
                    if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                        vc.errorText = "populateSavedWorkouts() @ SavedController.swift in data nil test"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            case .failure(_): // Block executed if conversion fails
                if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                    vc.errorText = "populateSavedWorkouts() @ SavedController.swift in failure case block"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
