//
//  InvoicesViewController.swift
//  Tawseel
//
//  Created by macbook on 16/03/2021.
//

import UIKit
import SideMenu
class BillsViewController: UIViewController {

    @IBOutlet weak var paidButton: UIButton!
    @IBOutlet weak var canceledButton: UIButton!
    @IBOutlet weak var billsTableView: UITableView!
    
    private var isPaid:Bool = true
    private var paidBills = [BillsInfo]()
    private var canceledBills = [BillsInfo]()
    private var menu :SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }

    @IBAction func paidAction(_ sender: Any) {
        paidButton.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.6509803922, blue: 0.1019607843, alpha: 1)
        canceledButton.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.1647058824, blue: 0.3411764706, alpha: 1)
        isPaid = true
        billsTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        billsTableView.reloadData()
    }
    
    @IBAction func canceledAction(_ sender: Any) {
        paidButton.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.1647058824, blue: 0.3411764706, alpha: 1)
        canceledButton.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.6509803922, blue: 0.1019607843, alpha: 1)
        isPaid = false
        billsTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        billsTableView.reloadData()
    }
    
    private func initlization(){
        setUpSideMenu()
        setUpTableView()
        getPaidBillsData()
        getCanceledBillsData()
    }
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    private func getPaidBillsData(){
        paidBills.append(BillsInfo(billNumber: "28173128736", deliveryAmount: 100, fromLocation: "kjdfhklaj", toLocation: "klasdlkasjdksald", isNew: true))
        
        paidBills.append(BillsInfo(billNumber: "28173128736", deliveryAmount: 100, fromLocation: "fghkgkl", toLocation: "klasdlkasjdksald", isNew: true))
        
        paidBills.append(BillsInfo(billNumber: "28173128736", deliveryAmount: 100, fromLocation: "zxckjh", toLocation: "klasdlkasjdksald", isNew: false))
        
        paidBills.append(BillsInfo(billNumber: "28173128736", deliveryAmount: 100, fromLocation: "fdkglj", toLocation: "klasdlkasjdksald", isNew: false))
        
        paidBills.append(BillsInfo(billNumber: "28173128736", deliveryAmount: 100, fromLocation: "klasdlaksdj", toLocation: "klasdlkasjdksald", isNew: false))
        paidBills.append(BillsInfo(billNumber: "28173128736", deliveryAmount: 100, fromLocation: "klasdlaksdj", toLocation: "klasdlkasjdksald", isNew: false))
        
        paidBills.append(BillsInfo(billNumber: "28173128736", deliveryAmount: 100, fromLocation: "klasdlaksdj", toLocation: "klasdlkasjdksald", isNew: false))
    }
    
    private func getCanceledBillsData(){
        canceledBills.append(BillsInfo(billNumber: "9845678956", deliveryAmount: 80, fromLocation: "kjdsfhkdjsfh", toLocation: "kdjfsmcoiroew"))
        
        canceledBills.append(BillsInfo(billNumber: "0912841290", deliveryAmount: 60, fromLocation: "xcvcxjvrepoiuf", toLocation: "asdiouqwdnsaidjewioflme"))
        
        canceledBills.append(BillsInfo(billNumber: "659780442", deliveryAmount: 90, fromLocation: "briuewthksd", toLocation: "asgfsxchasxlksxsac"))
        
        canceledBills.append(BillsInfo(billNumber: "8327562374", deliveryAmount: 93.5, fromLocation: "bkhjgoiphj", toLocation: "ogphjip,b"))
        
        canceledBills.append(BillsInfo(billNumber: "0569785690", deliveryAmount: 80, fromLocation: "xzkcjhxzcbnxzcv", toLocation: "hjpmo,oj"))
        canceledBills.append(BillsInfo(billNumber: "210382103", deliveryAmount: 12.7, fromLocation: "5486uoiyutor", toLocation: "viounvgeor"))
        
        canceledBills.append(BillsInfo(billNumber: "9486749023234", deliveryAmount: 55, fromLocation: "sdlkfhfqepofjof", toLocation: "wucnorpewjrfewo"))
    }
    
}

extension BillsViewController: UITableViewDelegate , UITableViewDataSource{
    private func setUpTableView(){
        billsTableView.delegate = self
        billsTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isPaid ? paidBills.count : canceledBills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillsTableViewCell", for: indexPath) as! BillsTableViewCell
        cell.setData(billInfo: isPaid ? paidBills[indexPath.row] : canceledBills[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BillsDetalisViewController") as! BillsDetalisViewController
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! BillsTableViewCell
        if isPaid , let isNew = paidBills[indexPath.row].isNew{
            cell.cellView.backgroundColor = isNew ? #colorLiteral(red: 0.9803921569, green: 0.6509803922, blue: 0.1019607843, alpha: 0.2) : .white
        }else{
            cell.cellView.backgroundColor = .white
        }
        
        cell.alpha = 0
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1
        }
    }
    
}


