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
    @IBOutlet weak var invoiceNumberLabel: UILabel!
    @IBOutlet weak var toLocationLabel: UILabel!
    @IBOutlet weak var fromLocationLabel: UILabel!
    @IBOutlet weak var deliveryaAmountLabel: UILabel!
    var delegate:InvoicationProtocol?
    var index:IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.masksToBounds = false
    }
    
    func setData(invoice:InvoiceInfo,indexPath:IndexPath) {
        index = indexPath
        driverName.text = invoice.driverName
        invoiceNumberLabel.text = invoice.invoiceNumber
        deliveryaAmountLabel.text = invoice.deliveryAmount
        fromLocationLabel.text = invoice.fromLocation
        toLocationLabel.text = invoice.toLocation
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
