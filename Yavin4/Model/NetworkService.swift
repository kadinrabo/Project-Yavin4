//
//  NetworkService.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/22/21.
//

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
    static let FreeControllers = Yavin4Data.FreeControllers
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
        case "Weeks_0_2":
            return NetworkService.StageSections.Weeks_0_2
        case "Weeks_2_8":
            return NetworkService.StageSections.Weeks_2_8
        case "Weeks_8_12":
            return NetworkService.StageSections.Weeks_8_12
        case "Weeks_12_20":
            return NetworkService.StageSections.Weeks_12_20
        case "Weeks_20_32":
            return NetworkService.StageSections.Weeks_20_32
        case "Weeks_32_50":
            return NetworkService.StageSections.Weeks_32_50
        default:
            return nil
        }
    }
    
    static func getFreeStageSections(with identifier: String) -> [Section]? {
        switch identifier {
        case "Weeks_0_2":
            return NetworkService.FreeControllers.StageController.Weeks_0_2
        case "Weeks_2_8":
            return NetworkService.FreeControllers.StageController.Weeks_2_8
        case "Weeks_8_12":
            return NetworkService.FreeControllers.StageController.Weeks_8_12
        case "Weeks_12_20":
            return NetworkService.FreeControllers.StageController.Weeks_12_20
        case "Weeks_20_32":
            return NetworkService.FreeControllers.StageController.Weeks_20_32
        case "Weeks_32_50":
            return NetworkService.FreeControllers.StageController.Weeks_32_50
        default:
            return nil
        }
    }
}
