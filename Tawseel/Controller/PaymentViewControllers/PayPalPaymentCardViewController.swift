//
//  PayPalPaymentCardViewController.swift
//  Tawseel
//
//  Created by macbook on 23/03/2021.
//

import UIKit
import SideMenu
class PayPalPaymentCardViewController: UIViewController {
    
    @IBOutlet weak var binButton: UIButton!
    @IBOutlet weak var cardRadioButton: UIButton!
    @IBOutlet weak var payPalView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var isSaveSwitch: UISwitch!
    private var menu :SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    @IBAction func binAction(_ sender: Any) {
        binButton.isHidden = true
        cardRadioButton.isHidden = true
        // remove card data
    }
    
    @IBAction func cardRadioButtonAction(_ sender: Any) {
        cardRadioButton.isSelected = !cardRadioButton.isSelected
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func paymentAction(_ sender: Any) {
    }
    
    private func initlization(){
        setUpSideMenu()
        setUpTextField()
    }
    
    private func setUpTextField(){
        emailTextField.borderStyle = .none
        passwordTextField.borderStyle = .none
    }
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
}
