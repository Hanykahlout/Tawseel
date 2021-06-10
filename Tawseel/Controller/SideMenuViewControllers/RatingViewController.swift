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
    
    
    
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    @IBOutlet weak var ratingTableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var ratingPopUpView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    
    private var refreshControl = UIRefreshControl()
    private var menu :SideMenuNavigationController?
    private var allRatings:[Rate] = [Rate]()
    private var currentIndexPath:IndexPath?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeSideMenuSide()
        backButton.setImage( L102Language.currentAppleLanguage() == "ar" ? #imageLiteral(resourceName: "front") : #imageLiteral(resourceName: "back"), for: .normal)
        getRatingData()
    }
    
    
    private func initlization(){
        commentTextField.delegate = self
        addLeftPadding(textField: commentTextField)
        setUpSideMenu()
        setUpTableView()
        setUpRefreshControl()
        setShadowViewAction()
        ratingPopUpView.layer.masksToBounds = false
    }
    
    
    private func addLeftPadding(textField:UITextField){
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12, height: textField.bounds.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
    }
    
    
    private func setUpRefreshControl(){
        refreshControl.addTarget(self, action: #selector(getRatingData), for: .valueChanged)
        ratingTableView.refreshControl = refreshControl
        
    }
    
    
    private func setShadowViewAction(){
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePopUp)))
        shadowView.isUserInteractionEnabled = true
    }
    
    
    @objc private func removePopUp(){
        shadowView.isHidden = true
        if !ratingPopUpView.isHidden{
            ratingPopUpView.isHidden = true
        }else if !newtworkAlertView.isHidden{
            newtworkAlertView.isHidden = true
        }
    }
    
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
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
    
    
    @objc private func getRatingData(){
        UserAPI.shard.getRatings(pageNumber: 1) { (status, messages, ratings) in
            if status{
                DispatchQueue.main.async {
                    self.allRatings = ratings!
                    self.ratingTableView.reloadData()
                }
            }else{
                GeneralActions.shard.monitorNetwork {
                    DispatchQueue.main.async {
                        self.titleLabel.text = messages[0]
                        self.shadowView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                } notConectedAction: {
                    DispatchQueue.main.async {
                        self.titleLabel.text = NSLocalizedString("Make sure you have internet", comment: "")
                        self.shadowView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                }
            }
            if self.refreshControl.isRefreshing{
                self.refreshControl.endRefreshing()
            }
        }
        
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func updateAvtion(_ sender: Any) {
        if let indexPath = currentIndexPath{
            let rate = allRatings[indexPath.row]
            UserAPI.shard.updateRate(ratingId: String(rate.id ?? -1), driverId: String(rate.driver!.id ?? -1), comment: commentTextField.text!, stars: ratingView.rating) { (status, messages) in
                if status{
                    self.getRatingData()
                    self.removePopUp()
                    self.commentTextField.endEditing(true)
                }else{
                    GeneralActions.shard.monitorNetwork {
                        DispatchQueue.main.async {
                            self.titleLabel.text = messages[0]
                            self.shadowView.isHidden = false
                            self.newtworkAlertView.isHidden = false
                        }
                    } notConectedAction: {
                        DispatchQueue.main.async {
                            self.titleLabel.text = NSLocalizedString("Make sure you have internet", comment: "")
                            self.shadowView.isHidden = false
                            self.newtworkAlertView.isHidden = false
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        removePopUp()
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
        let delegateRatingInfo:Rate = allRatings[indexPath.row]
        currentIndexPath = indexPath
        shadowView.isHidden = false
        ratingPopUpView.isHidden = false
        commentTextField.text = delegateRatingInfo.text ?? ""
        ratingView.rating = Double(delegateRatingInfo.stars ?? 0)
    }
    
}


extension RatingViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
}
