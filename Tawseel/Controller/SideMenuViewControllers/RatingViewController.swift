//
//  RatingViewController.swift
//  Tawseel
//
//  Created by macbook on 25/03/2021.
//

import UIKit
import SideMenu
import Cosmos
class RatingViewController: UIViewController {
    
    @IBOutlet weak var ratingTableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var ratingPopUpView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var commentTextField: UITextField!
    
    private var menu :SideMenuNavigationController?
    private var allRatings:[RatingInfo] = [RatingInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateAvtion(_ sender: Any) {
        removePopUp()
    }
    
    private func initlization(){
        setUpSideMenu()
        setUpTableView()
        getRatingData()
        setShadowViewAction()
        ratingPopUpView.layer.masksToBounds = false
    }
    
    private func setShadowViewAction(){
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePopUp)))
        shadowView.isUserInteractionEnabled = true
    }
    
    @objc private func removePopUp(){
        shadowView.isHidden = true
        ratingPopUpView.isHidden = true
    }
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    private func getRatingData(){
        allRatings.append(.init(delegateName: "Hani", delegateImage: #imageLiteral(resourceName: "personalImage"), userComment: "it's bad service, I don't recommend this man", ratingNumber: 3.4))
        allRatings.append(.init(delegateName: "Hani", delegateImage: #imageLiteral(resourceName: "personalImage"), userComment: "it's bad service, I don't recommend this man", ratingNumber: 3.4))
        allRatings.append(.init(delegateName: "Hani", delegateImage: #imageLiteral(resourceName: "personalImage"), userComment: "it's bad service, I don't recommend this man", ratingNumber: 3.4))
        allRatings.append(.init(delegateName: "Hani", delegateImage: #imageLiteral(resourceName: "personalImage"), userComment: "it's bad service, I don't recommend this man", ratingNumber: 3.4))
        allRatings.append(.init(delegateName: "Hani", delegateImage: #imageLiteral(resourceName: "personalImage"), userComment: "it's bad service, I don't recommend this man", ratingNumber: 3.4))
        allRatings.append(.init(delegateName: "Hani", delegateImage: #imageLiteral(resourceName: "personalImage"), userComment: "it's bad service, I don't recommend this man", ratingNumber: 3.4))
        allRatings.append(.init(delegateName: "Hani", delegateImage: #imageLiteral(resourceName: "personalImage"), userComment: "it's bad service, I don't recommend this man", ratingNumber: 3.4))
    }
    
}
extension RatingViewController: UITableViewDelegate , UITableViewDataSource {
    func setUpTableView() {
        ratingTableView.delegate = self
        ratingTableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRatings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTableViewCell", for: indexPath) as! RatingTableViewCell
        cell.setData(ratingInfo: allRatings[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let delegateRatingInfo:RatingInfo = allRatings[indexPath.row]
        shadowView.isHidden = false
        ratingPopUpView.isHidden = false
        commentTextField.text = delegateRatingInfo.userComment
        ratingView.rating = delegateRatingInfo.ratingNumber
    }
    
}
