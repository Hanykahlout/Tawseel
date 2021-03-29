//
//  BillsTableViewCell.swift
//  Tawseel
//
//  Created by macbook on 24/03/2021.
//

import UIKit

class BillsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deliveryAmountLabel: UILabel!
    
    @IBOutlet weak var billNumberLabel: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var fromLocationLabel: UILabel!
    
    @IBOutlet weak var toLocationLabel: UILabel!
    
    func setData(billInfo info :BillsInfo)  {
        deliveryAmountLabel.text = "\(info.deliveryAmount)SR"
        billNumberLabel.text = info.billNumber
        fromLocationLabel.text = info.fromLocation
        toLocationLabel.text = info.toLocation
    }
}

