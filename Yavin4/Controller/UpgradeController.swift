//
//  UpgradeController.swift
//  Yavin4
//
//  Created by Kadin Rabo on 6/11/21.
//

import StoreKit
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import SafariServices


// ######################################################
//MARK: ROOT DELEGATE METHOD(S)
// ######################################################

class UpgradeController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet var buyPremiumButton: UIButton!
    @IBOutlet var costLabel: UILabel!
    private var models = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.styleFilledButton(buyPremiumButton)
        SKPaymentQueue.default().add(self)
        fetchProducts()
        checkPaidStatus()
    }
}

// ######################################################
//MARK: PURCHASE STATE HANDLING METHOD(S)
// ######################################################

extension UpgradeController {
    
    func handlePurchasing() {
        print("handlePurchasing")
    }
    
    func handleFailed() {
        print("handleFailed func")
    }
    
    func handleRestored() {
        print("handleRestored")
    }
    
    func handleDeferred() {
        print("handleDeferred")
    }
    
    func handleUnknown() {
        print("handleUnknown")
    }
    
    func handlePurchased() {
        let userRef = Firestore.firestore().collection("yavin4-users").document(Auth.auth().currentUser!.uid)
        
        userRef.getDocument { document, error in
            let result = Result {
              try document?.data(as: User.self)
            }
            switch result {
            case .success(let data):
                if data != nil {
                    if !data!.paid {
                        userRef.updateData([
                            "paid":true
                        ])
                        let ac = Helper.quitApp(title: "Quit App", message: "Quit app to set app changes.")
                        self.present(ac, animated: true, completion: nil)
                    }
                } else {
                    if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                        vc.errorText = "handlePurchase() @ UpgradeController.swift in else data block"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            case .failure(_):
                if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                    vc.errorText = "handlePurchase() @ UpgradeController.swift in failure case block"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

// ######################################################
//MARK: BUTTON DELEGATE METHOD(S)
// ######################################################

extension UpgradeController {
    
    @IBAction func buyPremiumPressed(_ sender: Any) {
        let payment = SKPayment(product: models[0])
        SKPaymentQueue.default().add(payment)
    }
    
    @IBAction func escapePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func privacyPolicyPressed(_ sender: Any) {
        let url = URL(string: "https://www.apple.com/")
        let safariViewController = SFSafariViewController(url: url!)
        present(safariViewController, animated: true, completion: nil)
    }
    
    @IBAction func tOSPressed(_ sender: Any) {
        let url = URL(string: "https://www.apple.com/")
        let safariViewController = SFSafariViewController(url: url!)
        present(safariViewController, animated: true, completion: nil)
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        let url = URL(string: "https://www.apple.com/")
        let safariViewController = SFSafariViewController(url: url!)
        present(safariViewController, animated: true, completion: nil)
    }
}

// ######################################################
//MARK: PRODUCT DELEGATE METHOD(S)
// ######################################################

extension UpgradeController {
    
    private func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue })))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.models = response.products
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            switch $0.transactionState {
            case .purchasing:
                handlePurchasing()
            case .purchased:
                handlePurchased()
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                handleFailed()
            case .restored:
                handleRestored()
            case .deferred:
                handleDeferred()
            @unknown default:
                handleUnknown()
            }
        })
    }
}

// ######################################################
//MARK: PRODUCT DELEGATE METHOD(S)
// ######################################################

extension UpgradeController {
    
    func checkPaidStatus() {
        let userRef = Firestore.firestore().collection("yavin4-users").document(Auth.auth().currentUser!.uid)
        
        userRef.getDocument { document, error in
            let result = Result {
              try document?.data(as: User.self)
            }
            switch result {
            case .success(let data):
                if data != nil {
                    if data!.paid {
                        self.buyPremiumButton.backgroundColor = UIColor.secondaryLabel
                        self.buyPremiumButton.setTitle("Manage", for: .normal)
                        self.costLabel.textColor = UIColor.secondaryLabel
                    }
                } else {
                    if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                        vc.errorText = "checkPaidStatus() @ UpgradeController.swift in else data nil block"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            case .failure(_):
                if let vc = self.storyboard?.instantiateViewController(identifier: "Error") as? ErrorController {
                    vc.errorText = "checkPaidStatus() @ UpgradeController.swift in failure case block"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
