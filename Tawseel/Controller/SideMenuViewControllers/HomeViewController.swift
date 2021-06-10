//
//  HomeViewController.swift
//  Tawseel
//
//  Created by macbook on 16/03/2021.
//

import UIKit
import SideMenu
class HomeViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var endBtn: UIButton!
    @IBOutlet weak var currentBtn: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    private var currentOrder = [Order]()
    private var endedOrder = [Order]()
    private var isCurrent = true
    private var menu :SideMenuNavigationController?
    private let refreshControl = UIRefreshControl()
    private var endedCounter:Int = 1
    private var currrentCounter:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeSideMenuSide()
        getCurrentOrders(isFromBottom: false)
    }
    
    
    private func initlization() {
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
    
    
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    
    private func changeSideMenuSide(){
        if L102Language.currentAppleLanguage() == "ar"{
            backButton.setImage(#imageLiteral(resourceName: "front"), for: .normal)
            menu?.leftSide = true
            SideMenuManager.default.rightMenuNavigationController = nil
            SideMenuManager.default.leftMenuNavigationController = menu
        }else{
            backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
            menu?.leftSide = false
            SideMenuManager.default.leftMenuNavigationController = nil
            SideMenuManager.default.rightMenuNavigationController = menu
        }
    }
    
    
    private func setUpRefreshControl(){
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    
    @objc private func refresh(){
        isCurrent ? getCurrentOrders(isFromBottom: false) : getEndedOrder(isFromBottom: false)
    }
    
    
    private func getEndedOrder(isFromBottom:Bool){
        if !isFromBottom && endedCounter != 1{
            endedCounter = 1
        }
        UserAPI.shard.getFinishedOrders(pageNumber: endedCounter) { (status, messages, orders) in
            if status{
                DispatchQueue.main.async {
                    if isFromBottom{
                        self.endedOrder.append(contentsOf: orders!)
                    }else{
                        self.endedOrder = orders!
                    }
                    self.tableView.reloadData()
                    if !self.endedOrder.isEmpty && !isFromBottom{
                        self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
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
    
    
    private func getCurrentOrders(isFromBottom:Bool) {
        if !isFromBottom && currrentCounter != 1 {
            currrentCounter = 1
        }
        UserAPI.shard.getCurrentOrders(pageNumber: currrentCounter) { (status, messages, orders) in
            if status{
                DispatchQueue.main.async {
                    if isFromBottom{
                        self.currentOrder.append(contentsOf: orders!)
                    }else{
                        self.currentOrder = orders!
                    }
                    self.tableView.reloadData()
                    if !self.currentOrder.isEmpty && !isFromBottom{
                        self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
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
    
    
    @IBAction func endAction(_ sender: Any) {
        getEndedOrder(isFromBottom: false)
        endBtn.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.6509803922, blue: 0.1019607843, alpha: 1)
        currentBtn.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.1647058824, blue: 0.3411764706, alpha: 1)
        isCurrent = false
        tableView.reloadData()
    }
    
    
    @IBAction func currentAction(_ sender: Any) {
        getCurrentOrders(isFromBottom: false)
        currentBtn.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.6509803922, blue: 0.1019607843, alpha: 1)
        endBtn.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.1647058824, blue: 0.3411764706, alpha: 1)
        isCurrent = true
        tableView.reloadData()
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        removePopUp()
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension HomeViewController: UITableViewDelegate , UITableViewDataSource{
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isCurrent ? currentOrder.count : endedOrder.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell
        cell.setData(order: isCurrent ? currentOrder[indexPath.row] : endedOrder[indexPath.row],indexPath:indexPath)
        cell.delegate = self
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom == height {
            if isCurrent{
                currrentCounter += 1
                getCurrentOrders(isFromBottom: true)
            }else{
                endedCounter += 1
                getEndedOrder(isFromBottom: true)
            }
        }
    }
}


extension HomeViewController: InvoicationProtocol{
    func goToTracingViewController(indexPath:IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TracingViewController") as! TracingViewController
        vc.orderData = isCurrent ? currentOrder[indexPath.row] : endedOrder[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


