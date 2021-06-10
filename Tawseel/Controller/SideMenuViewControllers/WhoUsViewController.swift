//
//  WhoUsViewController.swift
//  Tawseel
//
//  Created by macbook on 25/03/2021.
//

import UIKit
import SideMenu
class WhoUsViewController: UIViewController {
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var whoUsTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    
    private var menu :SideMenuNavigationController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeSideMenuSide()
        backButton.setImage( L102Language.currentAppleLanguage() == "ar" ? #imageLiteral(resourceName: "front") : #imageLiteral(resourceName: "back"), for: .normal)
        getWhoUsText()
    }
    
    
    private func initlization(){
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
    
    
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
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
    
    
    private func getWhoUsText(){
        GeneralAPI.shard.whoUs { (status, messages, data) in
            if status{
                for text in data{
                    DispatchQueue.main.async {
                        self.whoUsTextView.text += "\(text)\n"
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
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
 
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        removePopUp()
    }
    
    
}
