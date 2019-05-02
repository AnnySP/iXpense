//
//  Categories.swift
//  iXpense
//
//  Created by Anny Shan on 4/29/19.
//  Copyright © 2019 Anny Shan. All rights reserved.
//

import Foundation
import Firebase


class Categories {
    var categoryArray: [Category] = []
    var transactions = Transactions()
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ())  {
        db.collection("categories").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                    return completed()
            }
            self.categoryArray = []
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                let category = Category(dictionary: document.data())
                category.documentID = document.documentID
                self.categoryArray.append(category)
            }
            completed()
        }
    }
    
    func updateTotal(completed: @escaping ()-> ()) {
//        let db = Firestore.firestore()
    
        for index in 0..<categoryArray.count {
            var categoryTotal = 0.0
            for transaction in transactions.transactionArray {
                print(transactions.transactionArray)
                if transactions.transactionArray[index].category == categoryArray[index].name {
                    categoryTotal = categoryTotal + transaction.amount
                    print(transaction.amount)
                }
            }
            print(categoryTotal)
            self.categoryArray[index].total = categoryTotal
            self.categoryArray[index].saveData { (success) in
                if success {
                    print("Success")
                } else {
                    print("Failure")
                }
            }
        }
        completed()
        
        
    }

}
