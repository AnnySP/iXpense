//
//  ViewController.swift
//  iXpense
//
//  Created by Anny Shan on 4/23/19.
//  Copyright © 2019 Anny Shan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn
//import Charts

class CategoryListViewController: UIViewController {
//    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var totalSpendingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var authUI: FUIAuth!
    var categories: Categories!
    var transactions: Transactions!
//    var newArray = [Transaction]()

    override func viewDidLoad() {
        super.viewDidLoad()
        categories = Categories()
        transactions = Transactions()
        
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        totalSpendingLabel.isHidden = true
        
        var totalspending = 0.0
        for category in categories.categoryArray {
            totalspending += category.total
        }
        
        totalSpendingLabel.text = "Your Total Spending: $\(totalspending)"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        transactions.loadData {
//            print("Transactions loaded")
//            print(self.transactions.transactionArray[0].amount)
            self.categories.loadData {
                for category in self.categories.categoryArray {
                    var categoryTotal = 0.0
                    for transaction in self.transactions.transactionArray {
                        print(transaction.category)
                        print(transaction.amount)
                        if transaction.category == category.name {
                            categoryTotal += transaction.amount
                            print("😃\(categoryTotal)")
                        }
                    }
                    category.total = categoryTotal
                }
                self.tableView.reloadData()
                print(self.categories.categoryArray[0].total)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
            tableView.isHidden = false
            totalSpendingLabel.isHidden = false
//            pieChartView.isHidden = false
        }
    }

//    func prepareForPieChart() {
////        pieChart.chartDescription?.text = ""
//        var amountOfCategory: [ChartDataEntry] = []
//        var labelOfCategory = [String]()
//        for index in 0..<categories.categoryArray.count {
//            let dataEntry = PieChartDataEntry(value: 0)
////            for i in 0...1 {
//            dataEntry.value = categories.categoryArray[index].total
//            dataEntry.label = categories.categoryArray[index].name
//            amountOfCategory.append(dataEntry.value)
//            labelOfCategory.append(dataEntry.label!)
//        }
//        let chartDataSet = PieChartDataSet(values: amountOfCategory, label: nil)
//        let chartData = PieChartData(dataSets: chartDataSet)
//
//        pieChartView.data = chartData
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTransactionList" {
//            segue.destination as! TransactionListViewController
            let destinationNC = segue.destination as! UINavigationController
            let destination = destinationNC.topViewController as! TransactionListViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.categoryName = categories.categoryArray[selectedIndexPath.row].name
            destination.categories = categories
            let currentCategory = categories.categoryArray[selectedIndexPath.row]
            print(currentCategory.name)
            destination.category = currentCategory
//            newArray = []
//            for transaction in transactions.transactionArray {
//                if transaction.category == currentCategory.name {
//                    newArray.append(transaction)
//                }
//            }
//            print("😆 \(newArray[0].category)")
//            destination.transactionPerCate = newArray
            destination.transactions = transactions
            
        } else if segue.identifier == "ShowCategory" {
            let destinationNC = segue.destination as! UINavigationController
            let destination = destinationNC.topViewController as! CategoryDetailViewController
            destination.categories = categories
            destination.transactions = transactions
            destination.transactions.transactionArray = transactions.transactionArray
            print("Correct")
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("^^^ Successfully signed out!")
            tableView.isHidden = true
            totalSpendingLabel.isHidden = true
//            pieChartView.isHidden = true
            signIn()
        } catch {
            tableView.isHidden = true
            totalSpendingLabel.isHidden = true
//            pieChartView.isHidden = true
            print("*** ERROR: Couldn't sign out")
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
}

extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = " \(categories.categoryArray[indexPath.row].name):  $\(categories.categoryArray[indexPath.row].total)"
        return cell
    }
}

extension CategoryListViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            // Assumes data will be isplayed in a tableView that was hidden until login was verified so unauthorized users can't see data.
            tableView.isHidden = false
            print("^^^ We signed in with the user \(user.email ?? "unknown e-mail")")
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        
        // Create an instance of the FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        
        // Set background color to white
        loginViewController.view.backgroundColor = UIColor.orange
        
        // Create a frame for a UIImageView to hold our logo
        let marginInsets: CGFloat = 16 // logo will be 16 points from L and R margins
        let imageHeight: CGFloat = 225 // the height of our logo
        let imageY = self.view.center.y - imageHeight // places bottom of UIImageView in the center of the login screen
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
        
        // Create the UIImageView using the frame created above & add the "logo" image
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
        loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
        return loginViewController
    }
}
