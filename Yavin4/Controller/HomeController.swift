//
//  HomeController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/2/21.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SafariServices
import FirebaseFirestoreSwift


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class HomeController: UICollectionViewController {

    var sections = [Section]()
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!  // Data source for configured cells
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()  // Empty snapshot
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()  // Checks if a user is logged in and navigates to landing page if not. Home controller is the initial view controller.
    }
}

// ######################################################
//MARK: VIEW DELEGATE METHOD(S)
// ######################################################

extension HomeController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {  // Deals with items selected in each section.

        guard let storyboardID = dataSource?.itemIdentifier(for: indexPath)?.description else {  // Gets the storyboardID associated with the selected item.
            if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {  // Show error controller with message. storyboardID is the only necessary property of all items.
                vc.errorText = "didSelectItem() @ HomeController.swift in guard block of storyboardID"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }

        let identifier = dataSource?.itemIdentifier(for: indexPath)?.identifier
        let title = dataSource?.itemIdentifier(for: indexPath)?.title
        let urlString = dataSource?.itemIdentifier(for: indexPath)?.url
        
        if storyboardID == "Workout" && identifier != nil {  // If the item is a workout with an identifier, show the workout
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Workout") as? WorkoutController {
                vc.workoutIdentifier = identifier
                vc.title = title
                self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            } else {
                let ac = Helper.createAlert(title: "Error", message: "Error performing request. [2]")
                present(ac, animated: true)
                return
            }
        } else if storyboardID == "Article" {  // If the item is an article, show it
            let url = URL(string: urlString!)
            let safariViewController = SFSafariViewController(url: url!)
            present(safariViewController, animated: true, completion: nil)
        } else {
            let ac = Helper.createAlert(title: "Error", message: "Error performing request. [3]")
            present(ac, animated: true)
            return
        }
    }
}

// ######################################################
//MARK: DATA DELEGATE METHOD(S)
// ######################################################

extension HomeController {
    
    private func sortForYouSection() {  // Sort all workouts for the for you section.
        let searchData = NetworkService.SearchSections[0].data!  // Gets an Item array with all available workouts.
        Firestore.firestore().collection("yavin4-users").document(Auth.auth().currentUser!.uid).addSnapshotListener { document, error in  // Gets the user's document with a snapshot listener, for realtime updates
            var dssString: String! = ""  // Holds rehab stage based on dss
            var dss: Int = 0  // Days since surgery
            
            let result = Result {  // Converts the user's firestore document into a User object
              try document?.data(as: User.self)
            }
            
            switch result {
            case .success(let data):  // If the conversion to a User object is successful, assign the result to data variable
                if let data = data {
                    dss = data.dss + Helper.daysSinceAccountCreated()  // Get days since account created and add it to initial days since surgery
                    dssString = Helper.stageFromDateSinceSurgery(dss: dss)  // Gets rehab stage based on calculated days since surgery
                    if dssString == "" {  // Block is run if days since surgery doesn't fit within rehab stage bounds
                        if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                            vc.errorText = "sortForYouSection() @ HomeController.swift in dssString empty block test"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        return
                    }
                    guard let items = Helper.getThreeItems(searchData: searchData, dssString: dssString) else {  // Gets three random items with the filter of the rehab stage
                        if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                            vc.errorText = "sortForYouSection() @ HomeController.swift in guard let block for getThreeItems"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        return
                    }
                    self.snapshot.deleteAllItems()  // Clears the current items in the snapshot
                    self.snapshot.appendSections(self.sections)  // Upload sections to snapshot
                    for section in self.sections {
                        self.snapshot.appendItems(section.data!, toSection: section)  // Upload items to snapshot
                    }
                    self.snapshot.deleteItems(self.sections[1].data!)  // Possibly redundant, but this clears any items in the second section to be filled
                    self.snapshot.appendItems(items, toSection: self.sections[1])  // Add the newly acquired items in the guard block to the second section of the snapshot
                    self.dataSource?.apply(self.snapshot, animatingDifferences: true)  // Apply the snapshot to the data source
                } else {  // Should execute if the data object is nil.
                    if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                        vc.errorText = "sortForYouSection() @ HomeController.swift in else block of document ref data nil"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            case .failure(_):  // Run if firestore document -> User object conversion fails
                if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                    vc.errorText = "sortForYouSection() @ HomeController.swift in .failure case block"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

// ######################################################
//MARK: VALIDATION METHOD(S)
// ######################################################

extension HomeController {
    
    func authenticateUser() {
        if Auth.auth().currentUser == nil {  // Navigates to landing view controller if there is no authenticated user
            let landingController = storyboard?.instantiateViewController(identifier: "Landing") as? LandingController
            self.navigationController?.pushViewController(landingController!, animated: true)
            view.window?.rootViewController = landingController
            view.window?.makeKeyAndVisible()
        } else {
            continueToHome()
        }
    }
    
    func continueToHome() {
        
        // Configure View
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureHierarchy()  // Configures barebone layout
        createDataSource()  // Configures the different sections by registering cells
        
        // Network Service
        sections = NetworkService.HomeSections
        if sections.isEmpty {
            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [1]")
            present(ac, animated: true)
            return
        }
        sortForYouSection()  // gets For You items and applies the new sections to the datasource
    }
}
