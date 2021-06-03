//
//  Helper.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/16/21.
//

import Foundation
import UIKit
import Firebase


class Helper {
    
    // ####################################################
    //MARK: BUTTON STYLE & VALIDATION METHOD(S)
    // ####################################################
    
    static func styleTextField(_ textfield:UITextField, width: CGFloat) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: width, height: 2)
        bottomLine.backgroundColor = UIColor.systemBlue.cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func styleFilledButton(_ button:UIButton) {
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    // ####################################################
    //MARK: SORT "FOR YOU" SECTION METHOD(S)
    // ####################################################
    
    static let early = 1...800
    static let mid = 800...801
    static let late = 801...802
    static let more = 802...803
    
    static func stageFromDateSinceSurgery(dss: Int) -> String {
        if early.contains(dss) {
            return "early"
        } else if mid.contains(dss) {
            return "mid"
        } else if late.contains(dss) {
            return "late"
        } else if more.contains(dss) {
            return "more"
        }
        return ""
    }
    
    static func getThreeItems(searchData: [Item], dssString: String) -> [Item]? {
        var items = [Item]()
        for i in 0..<searchData.count {
            if searchData[i].stage! == dssString {
                items.append(searchData[i])
            }
        }
        items.shuffle()
        if items.count < 3 {
            return nil
        }
        items = Array(items[0...2])
        return items
    }
    
    // ####################################################
    //MARK: INTEGER FROM TEXT FIELD METHOD(S)
    // ####################################################

    static func integer(from textField: UITextField) -> Int {
        guard let text = textField.text, let number = Int(text) else {
            return 0
        }
        return number
    }
    
    // ####################################################
    //MARK: UI ALERT METHOD(S)
    // ####################################################

    static func createAlert(title: String!, message: String!) -> UIAlertController {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        return ac
    }
    
    // ####################################################
    //MARK: SORT NETWORK WORKOUT SECTIONS METHOD(S)
    // ####################################################
    
    static func getWorkoutSections(with identifier: String) -> [Section] {
        var sections = [Section]()
        
        for i in 0..<NetworkService.WorkoutSections.count {  // Potential issue for too many workouts
            if NetworkService.WorkoutSections[i].identifier == identifier {
                sections.append(NetworkService.WorkoutSections[i])
            }
        }
        return sections
    }
    
    // ####################################################
    //MARK: CELL CONFIGURATION DELEGATION METHOD(S)
    // ####################################################
    
    static func configure<T: ConfigurableCell>(_ cellType: T.Type, with item: Item, for indexPath: IndexPath, collectionView: UICollectionView) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")  // Failure must quit app
        }
        cell.configure(with: item)
        return cell
    }
    
    // ####################################################
    //MARK: GET DATE SINCE SURGERY METHOD(S)
    // ####################################################
    
    static let dateFormatter = DateFormatter()
    
    static func daysSinceAccountCreated() -> Int {
        dateFormatter.dateFormat = "y-M-d"
        let signupDay = Auth.auth().currentUser?.metadata.creationDate
        let signupDayFormatted = dateFormatter.string(from: signupDay!)
        
        let today = NSDate()
        let todayFormatted = dateFormatter.string(from: today as Date)
        
        let date1 = dateFormatter.date(from: signupDayFormatted)!
        let date2 = dateFormatter.date(from: todayFormatted)!
        
        let diffs = Calendar.current.dateComponents([.day], from: date1, to: date2)
        return diffs.day!
    }
}
