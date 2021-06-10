//
//  BillsDetalisViewController.swift
//  Tawseel
//
//  Created by macbook on 24/03/2021.
//

import UIKit
import SideMenu
import CoreLocation
class BillsDetalisViewController: UIViewController {
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var serviceSeekerNameLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var billNumberLabel: UILabel!
    @IBOutlet weak var orderLocationLabel: UILabel!
    @IBOutlet weak var deliveryLocationLabel: UILabel!
    @IBOutlet weak var paymentAmountLabel: UILabel!
    
    @IBOutlet weak var orderLocationView: UIView!
    @IBOutlet weak var deliveryLocationView: UIView!
    @IBOutlet weak var paymentAmountView: UIView!
    
    @IBOutlet weak var billNumberTopLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    
    private var menu :SideMenuNavigationController?
    public var billId:Int!
    private var billOrder:Order?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.setImage( L102Language.currentAppleLanguage() == "ar" ? #imageLiteral(resourceName: "front") : #imageLiteral(resourceName: "back"), for: .normal)
        changeSideMenuSide()
        setBillOrderData()
    }
    
    
    private func initlization() {
        setUpViews()
        setUpSideMenu()
        setUpBlackView()
    }
    
    
    private func setUpBlackView(){
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePopUp)))
    }
    
    
    @objc private func removePopUp(){
        blackView.isHidden = true
        newtworkAlertView.isHidden = true
    }
    
    
    
    
    private func setBillOrderData(){
        billNumberTopLabel.text = String(billId)
        UserAPI.shard.getBillById(id: billId) { (status, messages, order) in
            if status{
                if let order = order{
                    DispatchQueue.main.async {
                        self.billOrder = order
                        self.serviceSeekerNameLabel.text = order.name
                        self.driverNameLabel.text = order.iDName
                        self.billNumberLabel.text = order.id != nil ? String(order.id!) : ""
                        self.orderLocationLabel.text = order.from_address
                        self.deliveryLocationLabel.text = order.to_address
                        self.paymentAmountLabel.text = String(order.price ?? -1)
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
    
    private func setUpViews(){
        centerView.layer.masksToBounds = false
        deleteButton.layer.masksToBounds = false
        
        orderLocationView.layer.masksToBounds = false
        deliveryLocationView.layer.masksToBounds = false
        paymentAmountView.layer.masksToBounds = false
    }
    
    
    
    @IBAction func deleteAction(_ sender: Any) {
        UserAPI.shard.deleteBillById(billId: String(billId)) { (status, messages) in
            if status{
                self.navigationController?.popViewController(animated: true)
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
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func mapAction(_ sender: Any) {
        let sender = sender as! UIButton
        if let order = billOrder{
            let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            vc.isFromBills = true
            if sender.tag == 0{
                if let fromLat = order.from_lat , let fromLong = order.from_lng{
                    vc.selectedLocation = CLLocationCoordinate2D(latitude: fromLat, longitude: fromLong)
                    vc.selectedLocationAddress = order.from_address ?? ""
                }
            }else{
                if let toLat = order.to_lat , let toLong = order.to_lng{
                    vc.selectedLocation = CLLocationCoordinate2D(latitude: toLat, longitude: toLong)
                    vc.selectedLocationAddress = order.to_address ?? ""
                }
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        removePopUp()
    }
}
