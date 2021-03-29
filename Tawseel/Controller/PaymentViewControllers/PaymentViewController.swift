//
//  PaymentViewController.swift
//  Tawseel
//
//  Created by macbook on 23/03/2021.
//

import UIKit
import SideMenu
class PaymentViewController: UIViewController {

    @IBOutlet weak var visaCardRadioButton: UIButton!
    @IBOutlet weak var masterCardRadioButton: UIButton!
    @IBOutlet weak var madaCardRadioButton: UIButton!
    @IBOutlet weak var paypalCardRadioButton: UIButton!
    @IBOutlet weak var applePayCardRadioButton: UIButton!
    @IBOutlet weak var STCPayCardRadioButton: UIButton!
    private var menu :SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()

    }
    
    @IBAction func visaCardRadioButtonAction(_ sender: Any) {
        visaCardRadioButton.isSelected = true
        masterCardRadioButton.isSelected = false
        madaCardRadioButton.isSelected = false
        paypalCardRadioButton.isSelected = false
        applePayCardRadioButton.isSelected = false
        STCPayCardRadioButton.isSelected = false
    }
    
    @IBAction func masterCardRadioButtonAction(_ sender: Any) {
        visaCardRadioButton.isSelected = false
        masterCardRadioButton.isSelected = true
        madaCardRadioButton.isSelected = false
        paypalCardRadioButton.isSelected = false
        applePayCardRadioButton.isSelected = false
        STCPayCardRadioButton.isSelected = false
    
    }
    
    @IBAction func madaCardRadioButtonAction(_ sender: Any) {
        visaCardRadioButton.isSelected = false
        masterCardRadioButton.isSelected = false
        madaCardRadioButton.isSelected = true
        paypalCardRadioButton.isSelected = false
        applePayCardRadioButton.isSelected = false
        STCPayCardRadioButton.isSelected = false
    
    }
    
    @IBAction func payPalCardRadioButtonAction(_ sender: Any) {
        visaCardRadioButton.isSelected = false
        masterCardRadioButton.isSelected = false
        madaCardRadioButton.isSelected = false
        paypalCardRadioButton.isSelected = true
        applePayCardRadioButton.isSelected = false
        STCPayCardRadioButton.isSelected = false
    
    }
    
    @IBAction func applePayCardRadioButtonAction(_ sender: Any) {
        visaCardRadioButton.isSelected = false
        masterCardRadioButton.isSelected = false
        madaCardRadioButton.isSelected = false
        paypalCardRadioButton.isSelected = false
        applePayCardRadioButton.isSelected = true
        STCPayCardRadioButton.isSelected = false
    
    }
    
    @IBAction func STCPayCardRadioButtonAction(_ sender: Any) {
        visaCardRadioButton.isSelected = false
        masterCardRadioButton.isSelected = false
        madaCardRadioButton.isSelected = false
        paypalCardRadioButton.isSelected = false
        applePayCardRadioButton.isSelected = false
        STCPayCardRadioButton.isSelected = true
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func addAction(_ sender: Any) {
        if visaCardRadioButton.isSelected {
            // Visa Card Action
        }else if masterCardRadioButton.isSelected{
            // Master Card Action
        }else if madaCardRadioButton.isSelected {
            // Mada Card Action
        }else if paypalCardRadioButton.isSelected {
            // PayPal Card Action
        }else if applePayCardRadioButton.isSelected {
            // Apple Pay Card Action
        }else if STCPayCardRadioButton.isSelected {
            // STC Pay Card Action
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "PaymentCardViewController") as! PaymentCardViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func initlization(){
        setUpSideMenu()
        visaCardRadioButton.isSelected = true
        
    }
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
}
