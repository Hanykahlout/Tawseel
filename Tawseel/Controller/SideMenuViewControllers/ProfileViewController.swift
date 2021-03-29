//
//  ProfileViewController.swift
//  Tawseel
//
//  Created by macbook on 25/03/2021.
//

import UIKit
import SideMenu
class ProfileViewController: UIViewController {

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
    
    private var menu :SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
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
    }
    
    private func initlization(){
        setUpSideMenu()
    }
    
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
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
        let alertC = UIAlertController(title: "Select You Choose", message: "Select the image for your profile", preferredStyle: .actionSheet)
        alertC.addAction(.init(title: "Select From Galary", style: .default, handler: { (action) in
            self.setImageBy(source: .photoLibrary)
        }))
        alertC.addAction(.init(title: "Take A Picture By The Camera", style: .default, handler: { (action) in
            self.setImageBy(source: .camera)
        }))
        alertC.addAction(.init(title: "Remove Current Picture", style: .destructive, handler: { (action) in
            self.userImage.image = #imageLiteral(resourceName: "emptyUserImage")
        }))
        alertC.addAction(.init(title: "Cancel", style: .cancel, handler: { (action) in
            alertC.dismiss(animated: true, completion: nil)
        }))
        present(alertC, animated: true, completion: nil)
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
