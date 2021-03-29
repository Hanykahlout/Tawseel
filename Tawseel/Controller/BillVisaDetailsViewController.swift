//
//  InvoiceDetailsViewController.swift
//  Tawseel
//
//  Created by macbook on 22/03/2021.
//

import UIKit
import SideMenu
class BillVisaDetailsViewController: UIViewController {
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

    private var menu :SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
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
    
    private func initlization(){
        setUpSideMenu()
        setUpViews()
        shadowBlackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backFromPopup)))
        shadowBlackView.isUserInteractionEnabled = true
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
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    @objc private func backFromPopup(){
        shadowBlackView.isHidden = true
        paymentPopupView.isHidden = true
    }
}


