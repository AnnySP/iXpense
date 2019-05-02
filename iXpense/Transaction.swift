//
//  Transaction.swift
//  iXpense
//
//  Created by Anny Shan on 4/29/19.
//  Copyright © 2019 Anny Shan. All rights reserved.
//

import Foundation
import Firebase

class Transaction {
    var category = ""
    var description = ""
    var amount = 0.0
    var documentID: String
    var postingUserID: String
    
    var dictionary: [String: Any] {
        return ["category": category, "description": description, "amount": amount, "documentID": documentID, "postingUserID": postingUserID]
    }
    
    init(category: String, description: String, amount: Double, documentID: String, postingUserID: String) {
        self.category = category
        self.description = description
        self.amount = amount
        self.documentID = documentID
        self.postingUserID = postingUserID
    }
    
    convenience init() {
        self.init(category: "", description: "", amount: 0.0, documentID: "", postingUserID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let category = dictionary["category"] as! String? ?? ""
        let description = dictionary["description"] as! String? ?? ""
        let amount = dictionary["amount"] as! Double? ?? 0.0
        let documentID = dictionary["documentID"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(category: category, description: description, amount: amount, documentID: documentID, postingUserID: postingUserID)
    }
    
    func saveData(completion: @escaping (Bool) -> ())  {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, we'll have an ID
        if self.documentID != "" {
            let ref = db.collection("transactions").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: updating document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked!
                    completion(true)
                }
            }
        } else { // Otherwise create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will create a new ID for us
            ref = db.collection("transactions").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("ERROR: adding document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked! Save the documentID in Spot’s documentID property
                    self.documentID = ref!.documentID
                    completion(true)
                }
            }
        }
    }
    
}
