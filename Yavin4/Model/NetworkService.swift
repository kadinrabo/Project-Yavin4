//
//  NetworkService.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/22/21.
//

import Foundation
import Firebase
import FirebaseStorage


class NetworkService {
    
    // ####################################################
    //MARK: VIDEO STORAGE REFERENCE
    // ####################################################
    
    static let gsReference = Storage.storage().reference(forURL: "gs://prototypes-5287e.appspot.com/")
    
    // ####################################################
    //MARK: GET CELL IMAGE METHOD(S)
    // ####################################################
    
    static func getCellImageURL(with image: String) -> URL! {
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/prototypes-5287e.appspot.com/o/yavin4-images%2F\(image).jpg?alt=media")!
        return url
    }
    
    // ####################################################
    //MARK: INITIAL APP DATA REQUEST AS PROPERTIES
    // ####################################################
    
    static let Yavin4Data = Bundle.main.decode(Controllers.self, from: "https://prototypes-5287e-default-rtdb.firebaseio.com/yavin4.json")
    static let HomeSections = Yavin4Data.HomeController
    static let StageSections = Yavin4Data.StageController
    static let SearchSections = Yavin4Data.SearchController
    static let SavedSections = Yavin4Data.SavedController
    static let SettingsSections = Yavin4Data.SettingsController
    static let StagesSections = Yavin4Data.StagesController
    static let WorkoutSections = Yavin4Data.WorkoutController
    
    // ####################################################
    //MARK: GET STAGE SECTIONS METHOD(S)
    // ####################################################
    
    static func getStageSections(with identifier: String) -> [Section]? {
        switch identifier {
        case "Early-Stage":
            return NetworkService.StageSections.EarlyStage
        case "Mid-Stage":
            return NetworkService.StageSections.MidStage
        case "Late-Stage":
            return NetworkService.StageSections.LateStage
        case "More":
            return NetworkService.StageSections.More
        default:
            return nil
        }
    }
}
