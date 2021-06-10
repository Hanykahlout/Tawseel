//
//  UserProfileViewController.swift
//  Tawseel
//
//  Created by macbook on 15/03/2021.
//

import UIKit
import GoogleMaps

class UserProfileViewController: UIViewController {
    
    
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var centerPopUpView: ViewDesignable!
    @IBOutlet weak var popUpImage: UIImageView!
    @IBOutlet weak var popUpLabel: UILabel!
    @IBOutlet weak var topView: UIViewCustomCornerRadius!
    @IBOutlet weak var userImageView: UIImageViewDesignable!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var detectLocationTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    
    private var userLocationLat:Double?
    private var userLocationLong:Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initlization()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillApperAction()
    }
    
    
    private func initlization() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        topView.setGradient(firstColor: #colorLiteral(red: 0.9803921569, green: 0.6509803922, blue: 0.1019607843, alpha: 1), secondColor: .black, startPoint: nil, endPoint: nil)
        blackView.isUserInteractionEnabled = true
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePopUpAction)))
    }
    
    
    private func viewWillApperAction(){
        let user = UserDefaultsData.shard.getUser()
        if let lat = user.gpsLat , let long = user.gpsLng{
            userLocationLat = lat
            userLocationLong = long
            getAddressFromCoordinate(currentLocation: CLLocationCoordinate2D(latitude: lat, longitude: long))
        }
    }
    
    
    private func performSave(){
        if let userLocationLat = userLocationLat, let userLocationLong = userLocationLong{
            UserAPI.shard.setProfileData(lat: userLocationLat, lng: userLocationLong, address: detectLocationTextField.text!, name: fullNameTextField.text!, phone: mobileNumberTextField.text!, avatar: userImageView.image) { (status, messages, user) in
                if status{
                    UserDefaultsData.shard.saveUser(user: user!)
                    DispatchQueue.main.async {
                        self.showPopUp(title: NSLocalizedString("The data has been saved successfully", comment: ""), image: #imageLiteral(resourceName: "SucessIcon"))
                    }
                }else{
                    GeneralActions.shard.monitorNetwork {
                        self.showPopUp(title: messages[0], image: #imageLiteral(resourceName: "errorIcon"))
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
            showPopUp(title: NSLocalizedString("You must specify your location in the map", comment: ""), image: #imageLiteral(resourceName: "errorIcon"))
        }
    }
    
    
    private func showPopUp(title:String,image:UIImage) {
        DispatchQueue.main.async {
            self.popUpImage.image = image
            self.popUpLabel.text = title
            self.blackView.isHidden = false
            self.centerPopUpView.isHidden = false
        }
        
    }
    
    
    @objc func removePopUpAction(){
        blackView.isHidden = true
        if !centerPopUpView.isHidden{
            centerPopUpView.isHidden = true
            if popUpImage.image == #imageLiteral(resourceName: "SucessIcon"){
                let vc = storyboard?.instantiateViewController(withIdentifier: "TabBarNav") as! UINavigationController
                navigationController?.present(vc, animated: true, completion: nil)
            }
        }else if !newtworkAlertView.isHidden{
            newtworkAlertView.isHidden = true
        }
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
            self.userImageView.image = #imageLiteral(resourceName: "emptyUserImage")
        }))
        alertC.addAction(.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action) in
            alertC.dismiss(animated: true, completion: nil)
        }))
        present(alertC, animated: true, completion: nil)
    }
    
    
    private func getAddressFromCoordinate(currentLocation:CLLocationCoordinate2D){
        GMSGeocoder.init().reverseGeocodeCoordinate(currentLocation) { (response, error) in
            if error != nil{
                return
            }
            if let response = response {
                let result = response.firstResult()?.thoroughfare ?? NSLocalizedString("location not determined", comment: "")
                self.detectLocationTextField.text = result
            }
        }
    }
    
    
    @IBAction func locationAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func imagePickerAction(_ sender: Any) {
        selectImageAction()
    }
    
    
    @IBAction func savingDataAction(_ sender: Any) {
        performSave()
    }
    
    
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        removePopUpAction()
    }
}

extension UserProfileViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    private func setImageBy(source:UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImageView.image = editingImage
        }else if let orginalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImageView.image = orginalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}


