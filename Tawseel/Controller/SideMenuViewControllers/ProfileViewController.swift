//
//  ProfileViewController.swift
//  Tawseel
//
//  Created by macbook on 25/03/2021.
//

import UIKit
import SideMenu
import CoreLocation
import GoogleMaps
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var fullNameView: UIView!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    private var menu :SideMenuNavigationController?
    private var userLocationLat:Double?
    private var userLocationLong:Double?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        changeSideMenuSide()
        backButton.setImage( L102Language.currentAppleLanguage() == "ar" ? #imageLiteral(resourceName: "front") : #imageLiteral(resourceName: "back"), for: .normal)
        getUserLocationData()
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
    
    private func getUserLocationData(){
        let user = UserDefaultsData.shard.getUser()
        if let lat = user.gpsLat , let long = user.gpsLng{
            userLocationLat = lat
            userLocationLong = long
            getAddressFromCoordinate(currentLocation: CLLocationCoordinate2D(latitude: lat, longitude: long))
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
    
    
    private func getAddressFromCoordinate(currentLocation:CLLocationCoordinate2D){
        GMSGeocoder.init().reverseGeocodeCoordinate(currentLocation) { (response, error) in
            if error != nil{
                return
            }
            if let response = response {
                let result = response.firstResult()?.thoroughfare ?? NSLocalizedString("location not determined", comment: "")
                DispatchQueue.main.async {
                    self.locationTextField.text = result
                }
            }
        }
    }
    
    
    private func makeTextFieldEditable(view:UIView,textField:UITextField){
        view.backgroundColor = .white
        textField.isEnabled = true
    }
    
    
    private func makeTextFieldUnEditable(view:UIView,textField:UITextField){
        view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        textField.isEnabled = false
    }
    
    
    private func selectImageAction() {
        let alertC = UIAlertController(title: NSLocalizedString("Select You Choose", comment: ""), message: NSLocalizedString("Select the image from your profile", comment: ""), preferredStyle: .actionSheet)
        alertC.addAction(.init(title: NSLocalizedString("Select From Galary", comment: ""), style: .default, handler: { (action) in
            self.setImageBy(source: .photoLibrary)
        }))
        alertC.addAction(.init(title: NSLocalizedString("Take A Picture By The Camera", comment: ""), style: .default, handler: { (action) in
            self.setImageBy(source: .camera)
        }))
        alertC.addAction(.init(title: NSLocalizedString("Remove Current Picture", comment: ""), style: .destructive, handler: { (action) in
            self.userImage.image = #imageLiteral(resourceName: "emptyUserImage")
        }))
        alertC.addAction(.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action) in
            alertC.dismiss(animated: true, completion: nil)
        }))
        present(alertC, animated: true, completion: nil)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    
    @IBAction func editableAction(_ sender: Any) {
        makeTextFieldEditable(view:locationView,textField:locationTextField)
        makeTextFieldEditable(view:fullNameView ,textField:fullNameTextField)
        makeTextFieldEditable(view:phoneNumberView ,textField:phoneNumberTextField)
        
        imagePickerButton.isEnabled = !imagePickerButton.isEnabled
        editButton.isHidden = true
        saveButton.isHidden = false
        mapButton.isEnabled = true
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        // save data action
        if let userLocationLat = userLocationLat, let userLocationLong = userLocationLong{
            UserAPI.shard.setProfileData(lat: userLocationLat, lng: userLocationLong, address: locationTextField.text!, name: fullNameTextField.text!, phone: phoneNumberTextField.text!, avatar: userImage.image) { (status, messages, user) in
                if status{
                    UserDefaultsData.shard.saveUser(user: user!)
                    GeneralActions.shard.showAlert(target: self, title: NSLocalizedString("Successfully Updated", comment: ""), message: NSLocalizedString("The data has been updated successfully", comment: ""))
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
        }else{
            GeneralActions.shard.showAlert(target: self, title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You must specify your location in the map", comment: ""))
        }
        
        // Make Editable For Text Field False
        makeTextFieldUnEditable(view: locationView,textField:locationTextField)
        makeTextFieldUnEditable(view: fullNameView,textField:fullNameTextField)
        makeTextFieldUnEditable(view: phoneNumberView ,textField:phoneNumberTextField)
        imagePickerButton.isEnabled = false
        editButton.isHidden = false
        saveButton.isHidden = true
        mapButton.isEnabled = false
    }
    
    
    @IBAction func selectPicAction(_ sender: Any) {
        selectImageAction()
    }
    
    
    @IBAction func mapAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        removePopUp()
    }
    
    
}

extension ProfileViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    private func setImageBy(source:UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImage.image = editingImage
        }else if let orginalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImage.image = orginalImage
        }
        dismiss(animated: true, completion: nil)
    }
}
