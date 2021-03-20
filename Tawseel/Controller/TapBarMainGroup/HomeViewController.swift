//
//  HomeViewController.swift
//  Tawseel
//
//  Created by macbook on 16/03/2021.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableVeiw: UITableView!
    @IBOutlet weak var endBtn: UIButton!
    @IBOutlet weak var currentBtn: UIButton!
    private var currentInvocation = [InvoiceInfo]()
    private var endedInvocation = [InvoiceInfo]()
    private var isCurrent = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    @IBAction func endAction(_ sender: Any) {
        endBtn.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.6509803922, blue: 0.1019607843, alpha: 1)
        currentBtn.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.1647058824, blue: 0.3411764706, alpha: 1)
        isCurrent = false
        tableVeiw.reloadData()
    }
    
    @IBAction func currentAction(_ sender: Any) {
        currentBtn.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.6509803922, blue: 0.1019607843, alpha: 1)
        endBtn.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.1647058824, blue: 0.3411764706, alpha: 1)
        isCurrent = true
        tableVeiw.reloadData()
    }
    
    private func initlization() {
        setUpTableView()
        getCurrentInvoication()
        getEndedIvoicationInfo()
    }
    
    private func getEndedIvoicationInfo(){
        endedInvocation.append(InvoiceInfo(driverName: "Ahmed Mostafa", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        endedInvocation.append(InvoiceInfo(driverName: "Kahled Eltalbany", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        endedInvocation.append(InvoiceInfo(driverName: "Ahmed Joha", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        endedInvocation.append(InvoiceInfo(driverName: "Sereen Mohmmed", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        endedInvocation.append(InvoiceInfo(driverName: "Osama aklsd", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        endedInvocation.append(InvoiceInfo(driverName: "Ahmed Mostafa", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        endedInvocation.append(InvoiceInfo(driverName: "Kahled Eltalbany", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        endedInvocation.append(InvoiceInfo(driverName: "Ahmed Joha", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        endedInvocation.append(InvoiceInfo(driverName: "Sereen Mohmmed", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        endedInvocation.append(InvoiceInfo(driverName: "Osama aklsd", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
    }
    
    private func getCurrentInvoication() {
        currentInvocation.append(InvoiceInfo(driverName: "Hany Alkahlout", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        currentInvocation.append(InvoiceInfo(driverName: "Hany Alkahlout", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        currentInvocation.append(InvoiceInfo(driverName: "Hany Alkahlout", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        currentInvocation.append(InvoiceInfo(driverName: "Hany Alkahlout", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        currentInvocation.append(InvoiceInfo(driverName: "Hany Alkahlout", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        currentInvocation.append(InvoiceInfo(driverName: "Hany Alkahlout", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        currentInvocation.append(InvoiceInfo(driverName: "Hany Alkahlout", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        currentInvocation.append(InvoiceInfo(driverName: "Hany Alkahlout", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        currentInvocation.append(InvoiceInfo(driverName: "Hany Alkahlout", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        currentInvocation.append(InvoiceInfo(driverName: "Hany Alkahlout", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
        currentInvocation.append(InvoiceInfo(driverName: "Hany Alkahlout", deliveryAmount: "50SK", invoiceNumber: "12903712", fromLocation: "Gaza-Almokhabrat", toLocation: "Gaza-AlRemal",fromLatLong: .init(latitude: 51.46209263047101, longitude: -0.012850463390350342),toLatLong:.init(latitude: 57.08362811751865, longitude:  -4.28653210401535) ,currentLatLong: .init(latitude: 54.2728027024216, longitude: -1.8585535883903503)))
    }

}

extension HomeViewController: UITableViewDelegate , UITableViewDataSource{
    private func setUpTableView() {
        tableVeiw.delegate = self
        tableVeiw.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isCurrent ? currentInvocation.count : endedInvocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableVeiw.dequeueReusableCell(withIdentifier: "InvoicationTableViewCell", for: indexPath) as! InvoicationTableViewCell
        cell.setData(invoice: isCurrent ? currentInvocation[indexPath.row] : endedInvocation[indexPath.row],indexPath:indexPath)
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: InvoicationProtocol{
    func goToTracingViewController(indexPath:IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TracingViewController") as! TracingViewController
        let info = isCurrent ? currentInvocation[indexPath.row] : endedInvocation[indexPath.row]
        vc.setLocations(invoctionInfo: InvoiceInfo(driverName: info.driverName, deliveryAmount: info.deliveryAmount, invoiceNumber: info.invoiceNumber, fromLocation: info.fromLocation, toLocation: info.toLocation, fromLatLong: info.fromLatLong, toLatLong: info.toLatLong, currentLatLong: isCurrent ? info.currentLatLong : nil))
        navigationController?.pushViewController(vc, animated: true)
    }
}
