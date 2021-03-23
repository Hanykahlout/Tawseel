//
//  InvoiceDetailsViewController.swift
//  Tawseel
//
//  Created by macbook on 22/03/2021.
//

import UIKit

class InvoiceDetailsViewController: UIViewController {

    @IBOutlet weak var nameOfApplicantTextField: UITextField!
    @IBOutlet weak var nameOfDeliveryPersonTextField: UITextField!
    @IBOutlet weak var invoiceNumberTextField: UITextField!
    @IBOutlet weak var orderSiteTextField: UITextField!
    @IBOutlet weak var deliverySiteTextField: UITextField!
    @IBOutlet weak var paymentAmountTextField: UITextField!
    @IBOutlet weak var shadowBlackView: UIView!
    @IBOutlet weak var paymentPopupView: UIView!
    @IBOutlet weak var scrolView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
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
    }
    
    @IBAction func bankAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func initlization(){
        shadowBlackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backFromPopup)))
        shadowBlackView.isUserInteractionEnabled = true
        scrolView.delegate = self
    }
    
    @objc private func backFromPopup(){
        shadowBlackView.isHidden = true
        paymentPopupView.isHidden = true
    }
}

extension InvoiceDetailsViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
        if scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > view.frame.width{
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }
}
