//
//  Models.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/11/21.
//

import Foundation


// ######################################################
//MARK: BASE MODEL(S)
// ######################################################

struct Controllers: Hashable, Codable {
    let HomeController: [Section]
    let StagesController: [Section]
    let StageController: Stages
    let WorkoutController: [Section]
    let SettingsController: [Section]
    let SavedController: [Section]
    let SearchController: [Section]
}

struct Section: Hashable, Codable {
    let type: String  // Only non optional property
    let identifier: String?
    let title: String?
    let subtitle: String?
    var data: [Item]?
}

struct Item: Hashable, Codable {
    let tag: String?
    let stage: String?
    let identifier: String?
    let title: String?
    let subtitle: String?
    let image: String?
    let description: String?  // Typically used for the type of the item
    let url: String?  // Typically used for articles in resources section
}

// ######################################################
//MARK: STAGES MODEL(S)
// ######################################################

struct Stages: Hashable, Codable {
    let EarlyStage: [Section]
    let MidStage: [Section]
    let LateStage: [Section]
    let More: [Section]
}

// ######################################################
//MARK: USER DATA MODEL(S)
// ######################################################

struct User: Hashable, Codable {
    let identifiers: [String]  // Saved item identifier arrays
    let saved: [Item]  // Saved items
    let dss: Int
}
