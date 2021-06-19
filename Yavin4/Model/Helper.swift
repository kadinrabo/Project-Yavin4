//
//  Helper.swift
//  Yavin4
//
//  Created by Kadin Rabo on 5/16/21.
//

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

    static let stage1 = 0...14  // 0-2 weeks
    static let stage2 = 15...56  // 2-8 weeks
    static let stage3 = 16...84  // 8-12 weeks
    static let stage4 = 85...140  // 12-20 weeks
    static let stage5 = 141...224  // 20-32 weeks
    static let stage6 = 225...350  // 32-50 weeks
    
    static func stageFromDateSinceSurgery(dss: Int) -> String {
        if stage1.contains(dss) {
            return "stage1"
        } else if stage2.contains(dss) {
            return "stage2"
        } else if stage3.contains(dss) {
            return "stage3"
        } else if stage4.contains(dss) {
            return "stage4"
        } else if stage5.contains(dss) {
            return "stage5"
        } else {
            return "stage6"  // Forces the user into Stage 6 if they've had the account for a long time
        }
    }
    
    static func getForYouItems(searchData: [Item], dssString: String) -> [Item]? {
        var items = [Item]()
        for i in 0..<searchData.count {
            if searchData[i].stage! == dssString {
                items.append(searchData[i])
            }
        }
        items.shuffle()
        if items.isEmpty {  // catches array count 0
            return nil
        }
        if items.count >= 3 {  // catches array count 3 and greater
            return Array(items[0...2])
        } else {  // catches array count 1, 2
            return Array(items[0..<searchData.count])
        }
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
    
    static func quitApp(title: String!, message: String!) -> UIAlertController {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            exit(1)
        }))
        return ac
    }
    
    // ####################################################
    //MARK: GET WORKOUT SECTIONS METHOD(S)
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
    
    static func getFreeWorkoutSections(with identifier: String) -> [Section] {
        var sections = [Section]()
        
        for i in 0..<NetworkService.FreeControllers.WorkoutController.count {  // Potential issue for too many workouts
            if NetworkService.FreeControllers.WorkoutController[i].identifier == identifier {
                sections.append(NetworkService.FreeControllers.WorkoutController[i])
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
