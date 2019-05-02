//
//  Transactions.swift
//  iXpense
//
//  Created by Anny Shan on 4/29/19.
//  Copyright © 2019 Anny Shan. All rights reserved.
//

import Foundation
import Firebase

class Transactions {
    var transactionArray: [Transaction] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ())  {
        db.collection("transactions").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.transactionArray = []
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                let transaction = Transaction(dictionary: document.data())
                transaction.documentID = document.documentID
                self.transactionArray.append(transaction)
            }
            completed()
        }
    }

}
