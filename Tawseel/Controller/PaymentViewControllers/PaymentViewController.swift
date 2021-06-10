//
//  PaymentViewController.swift
//  Tawseel
//
//  Created by macbook on 23/03/2021.
//

import UIKit
import SideMenu
class PaymentViewController: UIViewController {
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var paymentMethodsTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    private var paymentMethods = [PaymentMethodsInfo]()
    private var selectedMethod:PaymentMethodsInfo?
    private var menu :SideMenuNavigationController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            SideMenuManager.default.rightMenuNavigationController = nil
            SideMenuManager.default.leftMenuNavigationController = menu
        }else{
            SideMenuManager.default.leftMenuNavigationController = nil
            SideMenuManager.default.rightMenuNavigationController = menu
        }
    }
    
    
    private func initlization(){
        setUpSideMenu()
        setPaymentMethodData()
        setUpTableView()
        setUpBlackView()
    }
    

    private func setUpBlackView(){
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePopUp)))
    }
    
    
    @objc private func removePopUp(){
        blackView.isHidden = true
        newtworkAlertView.isHidden = true
    }
    
    private func setPaymentMethodData(){
        paymentMethods.append(.init(image: #imageLiteral(resourceName: "visaCard"), title: "Visa Card", isSelected: false))
        paymentMethods.append(.init(image: #imageLiteral(resourceName: "masterCard"), title: "Master Card", isSelected: false))
        paymentMethods.append(.init(image: #imageLiteral(resourceName: "madaCard"), title: "Mada Card", isSelected: false))
        paymentMethods.append(.init(image: #imageLiteral(resourceName: "paypalCard"), title: "Pay Pal Card", isSelected: false))
        paymentMethods.append(.init(image: #imageLiteral(resourceName: "appleCard"), title: "Apple Pay Card", isSelected: false))
        paymentMethods.append(.init(image: #imageLiteral(resourceName: "STCPayCard"), title: "STC Pay Card", isSelected: false))
    }
    
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    
    @IBAction func addAction(_ sender: Any) {
        if let selectedMethod = selectedMethod{
            if selectedMethod.image == #imageLiteral(resourceName: "paypalCard"){
                let vc = storyboard?.instantiateViewController(withIdentifier: "PayPalPaymentCardViewController") as! PayPalPaymentCardViewController
                navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "PaymentCardViewController") as! PaymentCardViewController
                navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            GeneralActions.shard.showAlert(target: self, title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You Should Selecte Payment Method", comment: ""))
        }
    }
 
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        removePopUp()
    }
}

extension PaymentViewController: UITableViewDelegate,UITableViewDataSource{
    private func setUpTableView(){
        paymentMethodsTableView.delegate = self
        paymentMethodsTableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethods.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeSelectedMethod(indexPath:indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath) as! PaymentMethodTableViewCell
        cell.setData(paymentMethodInfo: paymentMethods[indexPath.row])
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    
    private func changeSelectedMethod(indexPath:IndexPath){
        if !paymentMethods[indexPath.row].isSelected {
            paymentMethods[indexPath.row].isSelected = true
            selectedMethod = paymentMethods[indexPath.row]
            for index in 0..<paymentMethods.count{
                if paymentMethods[index].isSelected && paymentMethods[index].title != paymentMethods[indexPath.row].title {
                    paymentMethods[index].isSelected = false
                }
            }
            paymentMethodsTableView.reloadData()
        }
    }
}


extension PaymentViewController:PaymentMethod{
    func select(indexPath:IndexPath) {
        changeSelectedMethod(indexPath: indexPath)
    }
    
}
