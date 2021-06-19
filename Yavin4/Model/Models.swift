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

struct Free: Hashable, Codable {
    let HomeController: [Section]
    let StagesController: [Section]
    let StageController: Stages
    let WorkoutController: [Section]
    let SettingsController: [Section]
    let SavedController: [Section]
    let SearchController: [Section]
}

struct Controllers: Hashable, Codable {
    let FreeControllers: Free
    let HomeController: [Section]
    let StagesController: [Section]
    let StageController: Stages
    let WorkoutController: [Section]
    let SettingsController: [Section]
    let SavedController: [Section]
    let SearchController: [Section]
}

struct Section: Hashable, Codable {
    let type: String?
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
    let Weeks_0_2: [Section]  // 0-2 weeks
    let Weeks_2_8: [Section]  // 2-8 weeks
    let Weeks_8_12: [Section]  // 8-12 weeks
    let Weeks_12_20: [Section]  // 12-20 weeks
    let Weeks_20_32: [Section] // 20-32 weeks
    let Weeks_32_50: [Section]  // 32-50 weeks
}

// ######################################################
//MARK: USER DATA MODEL(S)
// ######################################################

struct User: Hashable, Codable {
    let identifiers: [String]  // Saved item identifier arrays
    let saved: [Item]  // Saved items
    let dss: Int
    let paid: Bool
}

// ######################################################
//MARK: PURCHASING IDENTIFIER(S)
// ######################################################

enum Product: String, CaseIterable {
    case paid = "com.example.Yavin4.paid"
}
