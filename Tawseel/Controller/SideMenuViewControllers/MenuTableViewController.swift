//
//  MenuTableViewController.swift
//  Tawseel
//
//  Created by macbook on 25/03/2021.
//

import UIKit

class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            profilePersonlyAction()
        case 1:
            ratingAction()
        case 2:
            settingsAction()
        case 3:
            whoWeAreAction()
        case 4:
            contactUsAction()
        case 5:
            privacyAction()
        case 6:
            shareAction()
        case 7:
            applicationRating()
        default:
            break
        }
    }
    
    private func profilePersonlyAction(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func ratingAction(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func settingsAction(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func whoWeAreAction(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "WhoUsViewController") as! WhoUsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func contactUsAction(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func privacyAction(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "PrivacyViewController") as! PrivacyViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func shareAction(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "ShareAppViewController") as! ShareAppViewController
        navigationController?.pushViewController(vc, animated: true)
    }
   
    private func applicationRating(){
        // nothing
    }
    
}
