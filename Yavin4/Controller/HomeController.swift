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

    @IBOutlet var upgradeButton: UIBarButtonItem!  // Upgrade button outlet for modifying text
    @IBOutlet var favoriteButton: UIBarButtonItem!
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
                vc.downButton.tintColor = UIColor.label
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
//MARK: BUTTON DELEGATE METHOD(S)
// ######################################################

extension HomeController {
    
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
                        self.upgradeButton.title = "Upgrade"
                        self.upgradeButton.tintColor = UIColor.systemBlue
                        self.upgradeButton.isEnabled = true
                        
                        self.favoriteButton.tintColor = UIColor.clear
                        self.favoriteButton.isEnabled = false
                    } else if data!.paid {
                        self.upgradeButton.title = "Manage"
                        self.upgradeButton.tintColor = UIColor.label
                        self.upgradeButton.isEnabled = true
                        
                        self.favoriteButton.tintColor = UIColor.label
                        self.favoriteButton.isEnabled = true
                    }
                } else {
                    if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                        vc.errorText = "updateNavBarButtons() @ HomeController.swift in else data nil block"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            case .failure(_):
                if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                    vc.errorText = "updateNavBarButtons() @ HomeController.swift in failure case block"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

// ######################################################
//MARK: DATA DELEGATE METHOD(S)
// ######################################################

extension HomeController {
    
    private func sortForYouSection(with searchData: [Item], forYouPosition: Int) {  // Sort all workouts for the for you section.
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
                    guard let items = Helper.getForYouItems(searchData: searchData, dssString: dssString) else {  // Gets three random items with the filter of the rehab stage
                        if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                            vc.errorText = "sortForYouSection() @ HomeController.swift in guard let block for Helper.getForYouItems"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        return
                    }
                    self.snapshot.deleteAllItems()  // Clears the current items in the snapshot
                    self.snapshot.appendSections(self.sections)  // Upload sections to snapshot
                    for section in self.sections {
                        self.snapshot.appendItems(section.data!, toSection: section)  // Upload items to snapshot
                    }
                    self.snapshot.deleteItems(self.sections[forYouPosition].data!)  // Possibly redundant, but this clears any items in the second section to be filled
                    self.snapshot.appendItems(items, toSection: self.sections[forYouPosition])  // Add the newly acquired items in the guard block to the second section of the snapshot
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
    
    func networkService() {
        Firestore.firestore().collection("yavin4-users").document(Auth.auth().currentUser!.uid).addSnapshotListener { document, error in
            let result = Result {
                try document?.data(as: User.self)
            }
            switch result {
            case .success(let data):
                if let data = data {
                    if !data.paid {
                        self.sections = NetworkService.FreeControllers.HomeController
                        if self.sections.isEmpty {
                            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [2]")
                            self.present(ac, animated: true)
                            return
                        }
                        self.sortForYouSection(with: NetworkService.FreeControllers.SearchController[0].data!, forYouPosition: 0)
                    } else if data.paid {
                        self.sections = NetworkService.HomeSections
                        if self.sections.isEmpty {
                            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [3]")
                            self.present(ac, animated: true)
                            return
                        }
                        self.sortForYouSection(with: NetworkService.SearchSections[0].data!, forYouPosition: 1)
                    } else {
                        if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                            vc.errorText = "continueToHome() @ HomeController.swift in else block of success case"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            case .failure(_):
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
        self.favoriteButton.tintColor = UIColor.clear
        self.favoriteButton.isEnabled = false
        self.upgradeButton.tintColor = UIColor.clear
        self.upgradeButton.isEnabled = false
        configureHierarchy()  // Configures barebone layout
        createDataSource()  // Configures the different sections by registering cells
        updateNavBarButtons()  // Change upgrade button to "Manage" if user paid. Only changes in app relaunch
        
        // Network Service
        networkService()
    }
}
