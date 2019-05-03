//
//  TranscationListViewController.swift
//  iXpense
//
//  Created by Anny Shan on 4/29/19.
//  Copyright © 2019 Anny Shan. All rights reserved.
//

import UIKit

class TransactionListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var CategoryLabel: UILabel!
    
    var category: Category!
    var categories = Categories()
    var transactions: Transactions!
    var categoryName: String!
//    var transactionPerCate = [Transaction]()
    var transactionPerCate = [Transaction]()
    var newArray = [Transaction]()
    var existingTrans = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        transactions = Transactions()
       
        tableView.delegate = self
        tableView.dataSource = self
        CategoryLabel.text = "Your transactions for \(categoryName ?? "Unkown Category")"
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        categories.loadData {
//            self.tableView.reloadData()
//        }
//        transactions.loadData {
//            self.tableView.reloadData()
//        }

//        prepareTrans(categoryName: categoryName)
        transactions.loadData {
            self.newArray = []
            for transaction in self.transactions.transactionArray {
                if transaction.category == self.category.name {
                    self.newArray.append(transaction)
                }
            }
            print("😆 \(self.newArray[0].category)")
            self.transactionPerCate = self.newArray
            self.tableView.reloadData()
        }
    }
    
//    @IBAction func unwindFromSegue(segue: UIStoryboardSegue) {
//        if segue.identifier == "unwind" {
//            let source = segue.source as! TransactionDetailViewController
//            self.categories = source.categories
//            print("Called")
//            self.navigationController?.setViewControllers([CategoryListViewController()], animated: true)
//        }
//    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTransactionDetail" {
            let destination = segue.destination as! TransactionDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.transaction = transactionPerCate[selectedIndexPath.row]
            destination.transactions = transactionPerCate
            destination.category = category
            destination.existingTrans = existingTrans
        } else {
            let destinationNC = segue.destination as! UINavigationController
            let destination = destinationNC.topViewController as! TransactionDetailViewController
//            let destination = segue.destination as! TransactionDetailViewController
            destination.category = category
            destination.transactions = transactionPerCate
            existingTrans = false
            destination.existingTrans = existingTrans
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
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func addTransactionButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
}

extension TransactionListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return transactionPerCate.count
//        return transactions.transactionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransactionTableViewCell
        cell.configureCell(transaction: transactionPerCate[indexPath.row])
        return cell
    }
}
