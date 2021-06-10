//
//  InvoiceDetailsViewController.swift
//  Tawseel
//
//  Created by macbook on 22/03/2021.
//

import UIKit
import SideMenu
class BillVisaDetailsViewController: UIViewController {
    
    
    
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var billNumberTopLabel: UILabel!
    @IBOutlet weak var serviceSeekerNameLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var billNumberLabel: UILabel!
    @IBOutlet weak var orderLocationLabel: UILabel!
    @IBOutlet weak var deliveryLocationLabel: UILabel!
    @IBOutlet weak var paymentAmountLabel: UILabel!
    @IBOutlet weak var orderLocationView: UIView!
    @IBOutlet weak var deliveryLocationView: UIView!
    @IBOutlet weak var paymentAmountView: UIView!
    @IBOutlet weak var shadowBlackView: UIView!
    @IBOutlet weak var paymentPopupView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    private var menu :SideMenuNavigationController?
    public var billId:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.setImage( L102Language.currentAppleLanguage() == "ar" ? #imageLiteral(resourceName: "front") : #imageLiteral(resourceName: "back"), for: .normal)
        changeSideMenuSide()
        getBillInfo()
    }
    
    
    private func initlization(){
        setUpSideMenu()
        setUpViews()
        shadowBlackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backFromPopup)))
        shadowBlackView.isUserInteractionEnabled = true
    }
    
    
    func getBillInfo(){
        billNumberTopLabel.text = String(billId)
        UserAPI.shard.getBillById(id: billId) { (status, messages, bill) in
            if status{
                if let bill = bill{
                    DispatchQueue.main.async {
                        self.serviceSeekerNameLabel.text = bill.name
                        self.driverNameLabel.text = bill.iDName
                        self.billNumberLabel.text = String(bill.id!)
                        self.orderLocationLabel.text = bill.from_address
                        self.deliveryLocationLabel.text = bill.to_address
                        self.paymentAmountLabel.text = String(bill.price ?? -1)
                    }
                }
            }else{
                GeneralActions.shard.monitorNetwork {
                    DispatchQueue.main.async {
                        self.titleLabel.text = messages[0]
                        self.shadowBlackView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                } notConectedAction: {
                    DispatchQueue.main.async {
                        self.titleLabel.text = NSLocalizedString("Make sure you have internet", comment: "")
                        self.shadowBlackView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                }
            }
        }
    }
    
    
    private func setUpViews(){
        orderLocationView.layer.masksToBounds = false
        deliveryLocationView.layer.masksToBounds = false
        paymentPopupView.layer.masksToBounds = false

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
    
    
    @objc private func backFromPopup(){
        shadowBlackView.isHidden = true
        if !paymentPopupView.isHidden {
            paymentPopupView.isHidden = true
        }else if !newtworkAlertView.isHidden {
            newtworkAlertView.isHidden = true
        }
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func mapAction(_ sender: Any) {
        
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
    }
    
    
    @IBAction func payBillAction(_ sender: Any) {
        shadowBlackView.isHidden = false
        paymentPopupView.isHidden = false
    }
    
    
    @IBAction func cashAction(_ sender: Any) {
        
        backFromPopup()
    }
    
    
    @IBAction func bankAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        navigationController?.pushViewController(vc, animated: true)
        
        backFromPopup()
    }
    
    
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
            backFromPopup()
    }
}


