//
//  MainTabBarViewController.swift
//  Tawseel
//
//  Created by macbook on 16/03/2021.
//

import UIKit
class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    private func initlization() {
        navigationController?.navigationBar.isHidden = true
        selectedIndex = 2
        
        
    }

    
    
}
