//
//  WorkoutController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/14/21.
//

import UIKit
import AVKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class WorkoutController: UICollectionViewController {
    
    @IBOutlet var bookmarkButton: UIBarButtonItem!  // Bookmark button outlet for changing fill
    @IBOutlet var downButton: UIBarButtonItem!
    var sections = [Section]()
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    var workoutIdentifier: String!
    var workoutTitle: String!
    var identifier: String!
    var image: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure View
        configureHierarchy()
        createDataSource()
        
        // Network Service
        sections = Helper.getWorkoutSections(with: workoutIdentifier)  // Takes all available workouts and sorts them for one with workout identifier
        if sections.isEmpty {
            let ac = Helper.createAlert(title: "Error", message: "Error displaying data. [11]")
            present(ac, animated: true)
            return
        }
        workoutTitle = sections[0].title!  // First section in array because the first and second have the same section properties
        identifier = sections[0].identifier!
        image = sections[0].data![0].image!
        setBookmarkFill()  // Checks if the workout has been saved against identifier and sets bookmark fill
        reloadData()  // Shows the screen data
    }
}

// ######################################################
//MARK: BUTTON DELEGATE METHOD(S)
// ######################################################

extension WorkoutController {
    
    func setBookmarkFill() {
        let userRef = Firestore.firestore().collection("yavin4-users").document(Auth.auth().currentUser!.uid)
        
        userRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: User.self)  // Tries to convert the user document to User object
            }
            switch result {
            case .success(let data):  // If conversion is successful
                if let data = data {
                    if data.identifiers.contains(self.identifier) {  // If the array of identifiers contains the identifier, set the bookmark to filled
                        self.bookmarkButton.image = UIImage(systemName: "bookmark.fill")
                    } else {
                        self.bookmarkButton.image = UIImage(systemName: "bookmark")
                    }
                } else {
                    if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                        vc.errorText = "setBookmarkFill() @ WorkoutController.swift in else block of data nil test"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            case .failure(_):  // Document conversion to User object failure
                if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                    vc.errorText = "setBookmarkFill() @ WorkoutController.swift in failure case block"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        let userRef = Firestore.firestore().collection("yavin4-users").document(Auth.auth().currentUser!.uid)  // Reference the user document
        
        userRef.getDocument { (document, error) in  // Convert user document to User object
            let result = Result {
              try document?.data(as: User.self)
            }
            switch result {
            case .success(let data):
                if let data = data {
                    if data.identifiers.contains(self.identifier) {  // If the identifier is contained in the user document
                        userRef.updateData([  // Remove the workout because the workout is contained
                            "saved": FieldValue.arrayRemove([
                                [
                                    "title":self.workoutTitle,
                                    "identifier":self.identifier,
                                    "image":self.image
                                ]
                            ]),
                            "identifiers": FieldValue.arrayRemove([
                                self.identifier!
                            ])
                        ])
                        self.bookmarkButton.image = UIImage(systemName: "bookmark")  // Set bookmark fill
                    } else if !data.identifiers.contains(self.identifier) {  // Add the workout
                        userRef.updateData([
                            "saved": FieldValue.arrayUnion([
                                [
                                    "title":self.workoutTitle,
                                    "identifier":self.identifier,
                                    "image":self.image
                                ]
                            ]),
                            "identifiers": FieldValue.arrayUnion([
                                self.identifier!
                            ])
                        ])
                        self.bookmarkButton.image = UIImage(systemName: "bookmark.fill")  // Set bookmark fill
                    } else {  // Block should never execute
                        if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                            vc.errorText = "@objc save() @ WorkoutController.swift in else block of case success block"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                } else {  // If data is nil, block executes
                    if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                        vc.errorText = "@objc save() @ WorkoutController.swift in else block of data nil test"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            case .failure(_):  // Conversion to User object failure
                if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                    vc.errorText = "@objc save() @ WorkoutController.swift in failure case block"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func downArrowPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// ######################################################
//MARK: VIDEO DELEGATE METHOD(S)
// ######################################################

extension WorkoutController {
    
    @IBAction func playVideo(_ sender: UIButton) {
        let video = NetworkService.gsReference.child("yavin4-videos/\(identifier!).mp4")
        video.downloadURL { url, error in
            if let error = error {
                let ac = Helper.createAlert(title: "Error Displaying Video", message: error.localizedDescription)
                self.present(ac, animated: true)
                return
            } else {
                let player = AVPlayer(url: url!)
                let playerController = AVPlayerViewController()
                playerController.videoGravity = .resizeAspectFill // Sets player controller to fill the whole screen
                playerController.player = player
                self.present(playerController, animated: true) { // Present the player and play
                    player.play()
                }
            }
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: .mixWithOthers) // .mixWithOthers prevents the video cancelling background audio such as music
            try AVAudioSession.sharedInstance().setActive(true) // Active audio session
        } catch {
            let ac = Helper.createAlert(title: "Error", message: error.localizedDescription)
            present(ac, animated: true)
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, options: [])
            } catch {
                let ac = Helper.createAlert(title: "Error", message: error.localizedDescription)
                present(ac, animated: true)
            }
        }
    }
}

// ######################################################
//MARK: DATA DELEGATE METHOD(S)
// ######################################################

extension WorkoutController {
    
    func reloadData() { // Apply sections to data source snapshot
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.data!, toSection: section)
        }
        dataSource?.apply(snapshot)
    }
}
