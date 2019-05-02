//
//  CategoryTableViewCell.swift
//  iXpense
//
//  Created by Anny Shan on 4/29/19.
//  Copyright © 2019 Anny Shan. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var transaction = Transaction()
    
    func configureCell(transaction: Transaction ) {
        descriptionLabel.text = transaction.description
        amountLabel.text = "$\(transaction.amount)"
    }
}
