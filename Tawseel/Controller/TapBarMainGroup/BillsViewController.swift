//
//  InvoicesViewController.swift
//  Tawseel
//
//  Created by macbook on 16/03/2021.
//

import UIKit
import SideMenu
class BillsViewController: UIViewController {
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    

    @IBOutlet weak var paidButton: UIButton!
    @IBOutlet weak var canceledButton: UIButton!
    @IBOutlet weak var billsTableView: UITableView!
    
    private var isPaid:Bool = true
    private var paidBills = [Order]()
    private var canceledBills = [Order]()
    private var menu :SideMenuNavigationController?
    private let refreshControl = UIRefreshControl()
    private var paidCounter:Int = 1
    private var canceledCounter:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    private func initlization(){
        setUpSideMenu()
        setUpTableView()
        setUpRefreshControl()
        setUpBlackView()
    }
    
    
    
    private func setUpBlackView(){
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePopUp)))
    }
    
    
    @objc private func removePopUp(){
        blackView.isHidden = true
        newtworkAlertView.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeSideMenuSide()
        getPaidBillsData(isFromBottom: false)
    }
    
    
    private func setUpRefreshControl(){
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        billsTableView.refreshControl = refreshControl
    }
    
    
    @objc private func refresh(){
        isPaid ? getPaidBillsData(isFromBottom: false) : getCanceledBillsData(isFromBottom: false)
    }
    
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    
    private func changeSideMenuSide(){
        if L102Language.currentAppleLanguage() == "ar"{
            menu?.leftSide = true
            SideMenuManager.default.rightMenuNavigationController = nil
            SideMenuManager.default.leftMenuNavigationController = menu
        }else{
            menu?.leftSide = false
            SideMenuManager.default.leftMenuNavigationController = nil
            SideMenuManager.default.rightMenuNavigationController = menu
        }
    }
    
    
    private func getPaidBillsData(isFromBottom:Bool){
        if !isFromBottom && paidCounter != 1{
            paidCounter = 1
        }
        UserAPI.shard.getPaidBills(pageNumber: paidCounter) { (status, messages, orders) in
            if status{
                DispatchQueue.main.async {
                    if !isFromBottom{
                        self.paidBills = orders!
                    }else{
                        self.paidBills.append(contentsOf: orders!)
                    }
                    self.paidBills.sort(){$0.created_at! > $1.created_at!}
                    self.billsTableView.reloadData()
                    if !orders!.isEmpty && !isFromBottom{
                        self.billsTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                    }
                }
            }else{
                GeneralActions.shard.monitorNetwork {
                    DispatchQueue.main.async {
                        self.titleLabel.text = messages[0]
                        self.blackView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                } notConectedAction: {
                    DispatchQueue.main.async {
                        self.titleLabel.text = NSLocalizedString("Make sure you have internet", comment: "")
                        self.blackView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                }
            }
        }
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
    }
    
    
    private func getCanceledBillsData(isFromBottom:Bool){
        UserAPI.shard.getCanceledBills(pageNumber: canceledCounter) { (status, messages, orders) in
            if status{
                DispatchQueue.main.async {
                    if !isFromBottom{
                        self.canceledBills = orders!
                    }else{
                        self.canceledBills.append(contentsOf: orders!)
                    }
                    self.canceledBills.sort(){$0.created_at! > $1.created_at!}
                    self.billsTableView.reloadData()
                    if !orders!.isEmpty && !isFromBottom{
                        self.billsTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                    }
                }
            }else{
                GeneralActions.shard.monitorNetwork {
                    DispatchQueue.main.async {
                        self.titleLabel.text = messages[0]
                        self.blackView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                } notConectedAction: {
                    DispatchQueue.main.async {
                        self.titleLabel.text = NSLocalizedString("Make sure you have internet", comment: "")
                        self.blackView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                }
            }
        }
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    
    @IBAction func paidAction(_ sender: Any) {
        getPaidBillsData(isFromBottom: false)
        paidButton.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.6509803922, blue: 0.1019607843, alpha: 1)
        canceledButton.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.1647058824, blue: 0.3411764706, alpha: 1)
        isPaid = true
        if !paidBills.isEmpty{
            billsTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        }
        billsTableView.reloadData()
    }
    
    
    @IBAction func canceledAction(_ sender: Any) {
        getCanceledBillsData(isFromBottom: false)
        paidButton.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.1647058824, blue: 0.3411764706, alpha: 1)
        canceledButton.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.6509803922, blue: 0.1019607843, alpha: 1)
        isPaid = false
        if !canceledBills.isEmpty{
            billsTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        }
        billsTableView.reloadData()
    }
 
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        removePopUp()
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
        vc.billId = isPaid ? paidBills[indexPath.row].id! : canceledBills[indexPath.row].id!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! BillsTableViewCell
        cell.alpha = 0
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom == height {
            if isPaid{
                paidCounter += 1
                getPaidBillsData(isFromBottom: true)
            }else{
                canceledCounter += 1
                getCanceledBillsData(isFromBottom: true)
            }
        }
    }
    
}


