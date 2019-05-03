//
//  CategoryDetailViewController.swift
//  iXpense
//
//  Created by Anny Shan on 4/29/19.
//  Copyright © 2019 Anny Shan. All rights reserved.
//

import UIKit

class CategoryDetailViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCategoryButton: UIBarButtonItem!
    
    var categories: Categories!
    var transactions: Transactions!
    var existingTrans = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        categories = Categories()
//
//        categories.loadData {
//            self.tableView.reloadData()
//            print(self.categories.categoryArray[0].total)
//        }
        print(self.transactions.transactionArray[0].amount)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categories.loadData {
            if !self.categories.categoryArray.isEmpty {
                print(self.categories.categoryArray[0].total)
            }
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTransactionWithCategory" {
            let destinationNC = segue.destination as! UINavigationController
            let destination = destinationNC.topViewController as! TransactionDetailViewController
            //let destination = segue.destination as! TransactionDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.categoryName = categories.categoryArray[selectedIndexPath.row].name
            destination.category = categories.categoryArray[selectedIndexPath.row]
            destination.categories = categories
            destination.transactions = transactions.transactionArray
            destination.existingTrans = existingTrans
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}


extension CategoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = categories.categoryArray[indexPath.row].name
        return cell
    }
}
