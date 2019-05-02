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
    
    var category: Category!
    var categories = Categories()
    var transactions: Transactions!
    var categoryName: String!
//    var transactionPerCate = [Transaction]()
    var transactionPerCate = [Transaction]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        transactions = Transactions()
       
        tableView.delegate = self
        tableView.dataSource = self
        
         tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        categories.loadData {
//            self.tableView.reloadData()
//        }
//        transactions.loadData {
//            self.tableView.reloadData()
//        }

//        prepareTrans(categoryName: categoryName)
    }
    
    func prepareTrans(categoryName: String) {
        for i in 0..<transactions.transactionArray.count {
            if transactions.transactionArray[i].category == categoryName {
                transactionPerCate.append(transactions.transactionArray[i])
            }
        }
    }
    
//    @IBAction func unwindFromSegue(segue: UIStoryboardSegue) {
//        if segue.identifier == "unwind" {
//            let source = segue.source as! TransactionDetailViewController
//            self.categories = source.categories
//            print("Called")
//            self.navigationController?.setViewControllers([CategoryListViewController()], animated: true)
//        }
//
//
//    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTransactionDetail" {
            let destination = segue.destination as! TransactionDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.transaction = transactions.transactionArray[selectedIndexPath.row]
        } else {
//            segue.destination as! TransactionDetailViewController
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
