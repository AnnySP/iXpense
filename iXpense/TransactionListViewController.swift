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
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
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
        transactions.loadData {
            self.newArray = []
            for transaction in self.transactions.transactionArray {
                if transaction.category == self.category.name {
                    self.newArray.append(transaction)
                }
            }
            self.transactionPerCate = self.newArray
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            transactions.transactionArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // First make a copy of the item that you are going to move
        let itemToMove = transactions.transactionArray[sourceIndexPath.row]
        // Delete item from the original location (pre-move)
        transactions.transactionArray.remove(at: sourceIndexPath.row)
        // Insert item into the "to", post-move, location
        transactions.transactionArray.insert(itemToMove, at: destinationIndexPath.row)
    }
    
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
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editButton.title = "Edit"
            addButton.isEnabled = true
            cancelButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editButton.title = "Done"
            addButton.isEnabled = false
            cancelButton.isEnabled = false
        }
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
