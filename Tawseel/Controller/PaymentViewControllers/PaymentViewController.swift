//
//  PaymentViewController.swift
//  Tawseel
//
//  Created by macbook on 23/03/2021.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var visaCardRadioButton: UIButton!
    @IBOutlet weak var masterCardRadioButton: UIButton!
    @IBOutlet weak var madaCardRadioButton: UIButton!
    @IBOutlet weak var paypalCardRadioButton: UIButton!
    @IBOutlet weak var applePayCardRadioButton: UIButton!
    @IBOutlet weak var STCPayCardRadioButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
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

    }
    
    private func initlization(){
        visaCardRadioButton.isSelected = true
        
    }
    
}
