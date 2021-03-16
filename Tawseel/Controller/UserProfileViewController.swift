//
//  UserProfileViewController.swift
//  Tawseel
//
//  Created by macbook on 15/03/2021.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var centerPopUpView: ViewDesignable!
    @IBOutlet weak var popUpImage: UIImageView!
    @IBOutlet weak var popUpLabel: UILabel!
    @IBOutlet weak var topView: UIViewCustomCornerRadius!
    @IBOutlet weak var userImageView: UIImageViewDesignable!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var detectLocationTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    func initlization() {
        scrollView.delegate = self
        navigationController?.navigationBar.isHidden = true
        topView.setGradient(firstColor: #colorLiteral(red: 0.9803921569, green: 0.6509803922, blue: 0.1019607843, alpha: 1), secondColor: .black, startPoint: nil, endPoint: nil)
    }
    @IBAction func locationAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func imagePickerAction(_ sender: Any) {
        selectImageAction()
    }
    @IBAction func savingDataAction(_ sender: Any) {
        // register user info process here
        showPopUp()
    }
    func showPopUp() {
        blackView.isHidden = false
        centerPopUpView.isHidden = false
        blackView.isUserInteractionEnabled = true
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removePopUpAction)))
    }
    @objc func removePopUpAction(){
        // here go to main view controller
        blackView.isHidden = true
        centerPopUpView.isHidden = true
    }
    
    func selectImageAction() {
        let alertC = UIAlertController(title: "Select You Choose", message: "Select the image for your profile", preferredStyle: .actionSheet)
        alertC.addAction(.init(title: "Select From Galary", style: .default, handler: { (action) in
            self.setImageBy(source: .photoLibrary)
        }))
        alertC.addAction(.init(title: "Take A Picture By The Camera", style: .default, handler: { (action) in
            self.setImageBy(source: .camera)
        }))
        alertC.addAction(.init(title: "Remove Current Picture", style: .destructive, handler: { (action) in
            self.userImageView.image = #imageLiteral(resourceName: "emptyUserImage")
        }))
        alertC.addAction(.init(title: "Cancel", style: .cancel, handler: { (action) in
            alertC.dismiss(animated: true, completion: nil)
        }))
        present(alertC, animated: true, completion: nil)
    }
}

extension UserProfileViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func setImageBy(source:UIImagePickerController.SourceType){
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

extension UserProfileViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }
}
