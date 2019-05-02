//
//  AddCategoryViewController.swift
//  iXpense
//
//  Created by Anny Shan on 4/29/19.
//  Copyright © 2019 Anny Shan. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var categoryTextField: UITextField!
    
    var category = Category()
    var categories: Categories!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
 
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func updateDataFromInterface() {
        //        var newCategory = Category(name: categoryTextField.text!, total: 0.0, documentID: "", postingUserID: "")
        //        categories.categoryArray.append(newCategory)
        category.name = categoryTextField.text ?? ""
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateDataFromInterface()
        category.saveData { success in
            print("in save data")
            //self.updateDataFromInterface()
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    

}
