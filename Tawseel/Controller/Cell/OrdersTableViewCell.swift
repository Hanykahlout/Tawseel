//
//  RequestsTableViewCell.swift
//  Tawseel
//
//  Created by macbook on 19/03/2021.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var toLocationLabel: UILabel!
    @IBOutlet weak var fromLocationLabel: UILabel!
    @IBOutlet weak var deliveryaAmountLabel: UILabel!
    
    var delegate:InvoicationProtocol?
    var index:IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.masksToBounds = false
    }
    
    
    func setData(order:Order,indexPath:IndexPath) {
        index = indexPath
        driverName.text = order.iDName ?? ""
        orderNumberLabel.text = order.bill_id ?? ""
        deliveryaAmountLabel.text = "\(order.price ?? -1) \(NSLocalizedString("SR", comment: ""))"
        fromLocationLabel.text = order.from_address
        toLocationLabel.text = order.to_address
    }
    
    
    @IBAction func tracingAction(_ sender: Any) {
        if let delegate = delegate {
            
            delegate.goToTracingViewController(indexPath: index)
        }
    }
    
    
}
protocol InvoicationProtocol {
    func goToTracingViewController(indexPath:IndexPath)
    
}
