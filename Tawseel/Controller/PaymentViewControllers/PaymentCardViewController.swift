//
//  PaymentCardViewController.swift
//  Tawseel
//
//  Created by macbook on 23/03/2021.
//

import UIKit
import SideMenu
class PaymentCardViewController: UIViewController {

    @IBOutlet weak var savedCardNumber: UILabel!
    @IBOutlet weak var cardView: GraidentView!
    @IBOutlet weak var visaRadioButton: UIButton!
    @IBOutlet weak var binButton: UIButton!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var isSaveSwitch: UISwitch!
    @IBOutlet weak var paymentButton: UIButton!
    private var menu :SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        
     }

    @IBAction func binAction(_ sender: Any) {
        visaRadioButton.isHidden = true
        binButton.isHidden = true
        // remove visa Data
        
    }
    
    @IBAction func visaRadionButtonAction(_ sender: Any) {
        visaRadioButton.isSelected = !visaRadioButton.isSelected
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func paymentAction(_ sender: Any) {
        
    }
    
    private func initlization(){
        cardView.layer.masksToBounds = true
        setUpSideMenu()
        setUpTextField()
    }
    
    private func setUpTextField(){
        cardNumberTextField.borderStyle = .none
            userNameTextField.borderStyle = .none
            cvvTextField.borderStyle = .none
            endDateTextField.borderStyle = .none
    }
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    
}


