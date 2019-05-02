//
//  TransactionDetailViewController.swift
//  iXpense
//
//  Created by Anny Shan on 4/29/19.
//  Copyright © 2019 Anny Shan. All rights reserved.
//

import UIKit

class TransactionDetailViewController: UIViewController {
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    var category: Category!
    var categories: Categories!
    var transaction: Transaction!
    var transactions: Transactions!
    var categoryName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if transaction == nil {
            transaction = Transaction()
        }
//        transactions = Transactions()
//        transactions.loadData {
//            print(self.transactions.transactionArray[0].amount)
//        }
        
        updateUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print(categories.categoryArray[0].total)
    }
    
    func updateUserInterface() {
        categoryTextField.text = categoryName
        //descriptionTextField.text = transaction.description
        //amountTextField.text = "\(transaction.amount)"
    }
    
    func updateDataFromInterface() {
        transaction.category = categoryTextField.text!
        transaction.description = descriptionTextField.text!
        transaction.amount = Double(amountTextField.text!)!
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        var categoryTotal = 0.0
       print(transactions.transactionArray[0].amount)
        for transaction in transactions.transactionArray {
            if transaction.category == category.name {
                categoryTotal += transaction.amount
                category.total = categoryTotal
            }
        }
        print("😃\(categoryTotal)")
        print(category.total)
        category.saveData { (success) in
            if success {
                print("Great Success")
                self.updateDataFromInterface()
                self.transaction.saveData { success in
                    if success {
                        self.leaveViewController()
                        
                        
                    } else {
                        print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
                    }
                }
            } else {
                print("****ERROR")
            }
        }
        
        
        
//            for category in categories.categoryArray {
//                print("in categories")
//                var categoryTotal = 0.0
//                for transaction in self.transactions.transactionArray {
//                    print(self.transactions.transactionArray)
//                    if transaction.category == categoryName {
//                        categoryTotal = categoryTotal + transaction.amount
//                        print(transaction.amount)
//                    }
//                    category.total = categoryTotal
//                    self.category.saveData { (success) in
//                        if success {
//                            print("Great Success")
//                        } else {
//                            print("****ERROR")
//                        }
//                    }
//                }
        
//            self.updateDataFromInterface()
//            self.transaction.saveData { success in
//                if success {
//                    self.leaveViewController()
//
//
//                } else {
//                    print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
//                }
//            }
        
}
}
//}
