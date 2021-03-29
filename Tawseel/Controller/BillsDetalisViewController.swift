//
//  BillsDetalisViewController.swift
//  Tawseel
//
//  Created by macbook on 24/03/2021.
//

import UIKit
import SideMenu
class BillsDetalisViewController: UIViewController {

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
    
    private var menu :SideMenuNavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()

    }

    @IBAction func deleteAction(_ sender: Any) {

    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func mapAction(_ sender: Any) {
    }
    
    
    
    private func initlization() {
        setUpViews()
        setUpSideMenu()
    }
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    private func setUpViews(){
        centerView.layer.masksToBounds = false
        deleteButton.layer.masksToBounds = false
        
        orderLocationView.layer.masksToBounds = false
        deliveryLocationView.layer.masksToBounds = false
        paymentAmountView.layer.masksToBounds = false
    }
    
}
