//
//  MenuViewController.swift
//  Tawseel
//
//  Created by macbook on 24/03/2021.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var topView: UIViewCustomCornerRadius!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.setGradient(firstColor: #colorLiteral(red: 0.6549019608, green: 0.8352941176, blue: 1, alpha: 1), secondColor: #colorLiteral(red: 0.737254902, green: 0.4705882353, blue: 0.02352941176, alpha: 1), startPoint: nil, endPoint: nil)
    }
        
    @IBAction func logoutAction(_ sender: Any) {
        performLogout()
    }
    
    private func performLogout(){
        UserAPI.shared.logout { (status) in
            if status{
                UserDefaultsData.shared.clearUserData()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AuthNav") as! UINavigationController
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
    }
}


