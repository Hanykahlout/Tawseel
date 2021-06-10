//
//  ChatViewController.swift
//  Tawseel
//
//  Created by macbook on 13/04/2021.
//

import UIKit
import Cosmos
import SideMenu       
import AVFoundation
import AVKit
import Contacts
import ContactsUI
class ChatViewController: UIViewController {
    
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageViewBottomConstrant: NSLayoutConstraint!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var shopsButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var productiveFamiliesButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var attachedView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var voiceMessageButton: UIButton!
    @IBOutlet weak var voiceButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var voiceButtonWidth: NSLayoutConstraint!
    
    private var player: AVAudioPlayer?
    private var audioFilename:URL!
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    
    private var menu :SideMenuNavigationController?
    private var messages = [ChatMessage]()
    private var isFirst:Bool = true
    private var driverImageUrl:String?
    
    var isMap:Bool!
    var driverId:Int!
    var orderId:Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            messageViewBottomConstrant.constant = -( keyboardRectangle.height + 10)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.setImage( L102Language.currentAppleLanguage() == "ar" ? #imageLiteral(resourceName: "front") : #imageLiteral(resourceName: "back"), for: .normal)
        changeSideMenuSide()
        setDriverData()
    }
    
    
    private func initlization(){
        setUpKeyboardHeight()
        addLeftPadding(textField: messageTextField)
        adjustsFontSizeButtons()
        setUpSideMenu()
        setUpTableView()
        setUpGestureRecognizers()
        messageTextField.delegate = self
        setUpRecoredVoice()
    }
    
    
    private func setUpKeyboardHeight(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    
    @objc private func endEditing(){
        messageTextField.endEditing(true)
        messageViewBottomConstrant.constant = -36
    }
    
    
    private func setUpGestureRecognizers(){
        chatTableView.isUserInteractionEnabled = true
        chatTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        
        shadowView.isUserInteractionEnabled = true
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endAttachedAction)))
        
    }
    
    
    @objc private func endAttachedAction(){
        attachedView.isHidden = true
        newtworkAlertView.isHidden = true
        shadowView.isHidden = true
    }
    
    
    private func adjustsFontSizeButtons(){
        locationButton.titleLabel!.adjustsFontSizeToFitWidth = true
        contactButton.titleLabel!.adjustsFontSizeToFitWidth = true
        shopsButton.titleLabel!.adjustsFontSizeToFitWidth = true
        photosButton.titleLabel!.adjustsFontSizeToFitWidth = true
        productiveFamiliesButton.titleLabel!.adjustsFontSizeToFitWidth = true
        videoButton.titleLabel!.adjustsFontSizeToFitWidth = true
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
    
    
    private func setDriverData(){
        if isMap{
            UserAPI.shard.getChatData(id: "\(String(self.driverId))", orderId: nil) { (status, messages, chat_info) in
                if status{
                    if let chatInfo = chat_info, let driverData = chatInfo.driver{
                        DispatchQueue.main.async {
                            
                            self.driverName.text = driverData.iDName ?? ""
                            self.driverImageUrl = "http://tawseel.pal-dev.com\(driverData.avatar ?? "")"
                            self.driverImage.sd_setImage(with: URL(string: self.driverImageUrl!), placeholderImage: #imageLiteral(resourceName: "personalImage"))
                            self.ratingView.rating = Double(driverData.stars ?? 0)
                        }
                    }
                }else{
                    GeneralActions.shard.monitorNetwork {
                        self.titleLabel.text = messages[0]
                        self.shadowView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                        
                    } notConectedAction: {
                        self.titleLabel.text = NSLocalizedString("Make sure you have internet", comment: "")
                        self.shadowView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                }
            }
        }else{
            UserAPI.shard.getChatData(id: "\(String(self.driverId))", orderId: String(orderId)) { (status, messages, chat_info) in
                if status{
                    if let chatInfo = chat_info, let driverData = chatInfo.driver , let messages = chatInfo.messages{
                        DispatchQueue.main.async {
                            
                            self.driverName.text = driverData.iDName ?? ""
                            let imageUrl = "http://tawseel.pal-dev.com\(driverData.avatar ?? "")"
                            self.driverImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "personalImage"))
                            self.ratingView.rating = Double(driverData.stars ?? 0)
                            self.messages = messages
                            self.chatTableView.reloadData()
                            if !self.messages.isEmpty{
                                self.chatTableView.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                            }
                        }
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
            }
        }
    }
    
    
    private func setUpRecoredVoice(){
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if !allowed {
                        self.titleLabel.text = NSLocalizedString("There are no permissions for voice message", comment: "")
                        self.shadowView.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.titleLabel.text = NSLocalizedString("There is an error for enabling voice messages", comment: "")
                self.shadowView.isHidden = false
                self.newtworkAlertView.isHidden = false
            }
        }
    }
    
    
    func startRecording() {
        audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            // make voice message buttom bigger
            
            UIView.animate(withDuration: 0.5) {
                DispatchQueue.main.async {
                    self.voiceButtonHeight.constant = 100
                    self.voiceButtonWidth.constant = 100
                    self.voiceMessageButton.setImage(UIImage(named: "voiceButton100")!, for: .normal)
                }
            }
            
        } catch {
            finishRecording(success: false)
        }
    }
    
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        UIView.animate(withDuration: 0.5) {
            DispatchQueue.main.async {
                self.voiceButtonHeight.constant = 36
                self.voiceButtonWidth.constant = 36
                self.voiceMessageButton.setImage(#imageLiteral(resourceName: "voiceButton50"), for: .normal)
            }
        }
        if success {
            // make new voice message with the new record
            if !isMap{
                isFirst = false
            }
            UserAPI.shard.sendFileMessage(image:nil,url: audioFilename, to: driverId!, type: "audio", isFirst: isFirst, orderId: isFirst ? nil : orderId) { (status, messages, chatData) in
                if status{
                    if let message = chatData{
                        self.messages.append(message)
                        self.chatTableView.reloadData()
                        if !self.messages.isEmpty{
                            self.chatTableView.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                        }
                        if self.isFirst{
                            self.orderId = message.order_id!
                            self.isFirst = false
                        }
                    }
                }else{
                    GeneralActions.shard.monitorNetwork {
                        DispatchQueue.main.async {
                            self.titleLabel.text = NSLocalizedString("There is an error while you are recording audio", comment: "")
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
        } else {
            // recording failed :(
            DispatchQueue.main.async {
                self.titleLabel.text = NSLocalizedString("There is an error while you are recording audio", comment: "")
                self.shadowView.isHidden = false
                self.newtworkAlertView.isHidden = false
            }
        }
    }
    
    
    @IBAction func sideMenuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    
    @IBAction func addAttachedAction(_ sender: Any) {
        shadowView.isHidden = false
        attachedView.isHidden = false
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func voiceMessageAction(_ sender: Any) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        send()
    }
    
    
    @IBAction func locationAction(_ sender: Any) {
    }
    
    
    @IBAction func contactAction(_ sender: Any) {
        let vc = CNContactPickerViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func shopsAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.titleLabel.text = NSLocalizedString("Unavailable at the moment", comment: "")
            self.shadowView.isHidden = false
            self.newtworkAlertView.isHidden = false
        }
    }
    
    
    @IBAction func photosAction(_ sender: Any) {
        setImageBy(source: .photoLibrary,mediaType: "public.image")
    }
    
    
    @IBAction func productiveFamiliesAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.titleLabel.text = NSLocalizedString("Unavailable at the moment", comment: "")
            self.shadowView.isHidden = false
            self.newtworkAlertView.isHidden = false
        }
    }
    
    
    @IBAction func videoAction(_ sender: Any) {
        setImageBy(source: .photoLibrary,mediaType: "public.movie")
    }
    
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        endAttachedAction()
    }
}


extension ChatViewController:UITableViewDelegate,UITableViewDataSource{
    func setUpTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        switch message.type {
        case "text":
            if message.sender_type! == "user"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageTableViewCell", for: indexPath) as! MyMessageTableViewCell
                cell.setData(message: message ,image: UserDefaultsData.shard.getUser().avatar ?? "")
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherMessageTableViewCell", for: indexPath) as! OtherMessageTableViewCell
                cell.setData(message: message, image: driverImageUrl ?? "")
                return cell
            }
        case "audio":
            if message.sender_type! == "user"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageTableViewCell", for: indexPath) as! MyMessageTableViewCell
                cell.setData(message: message, image:UserDefaultsData.shard.getUser().avatar ?? "")
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherMessageTableViewCell", for: indexPath) as! OtherMessageTableViewCell
                cell.setData(message: message, image: driverImageUrl ?? "")
                return cell
            }
            
        case "image":
            if message.sender_type! == "user"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyImageMessageTableViewCell", for: indexPath) as! MyImageMessageTableViewCell
                cell.setData(message: message, image:UserDefaultsData.shard.getUser().avatar ?? "")
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherImageMessageTableViewCell", for: indexPath) as! OtherImageMessageTableViewCell
                cell.setData(message: message, image:UserDefaultsData.shard.getUser().avatar ?? "")
                return cell
            }
        case "video":
            if message.sender_type! == "user"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyVideoMessageTableViewCell", for: indexPath) as! MyVideoMessageTableViewCell
                cell.setData(message: message, image:UserDefaultsData.shard.getUser().avatar ?? "")
                cell.delegate = self
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "OtherVideoMessageTableViewCell", for: indexPath) as! OtherVideoMessageTableViewCell
                cell.setData(message: message, image:UserDefaultsData.shard.getUser().avatar ?? "")
                cell.delegate = self
                return cell
            }
            
        case "map":
            
            break
            
        case "contact":
            break
        case "store":
            break
            
        case "productive_families":
            break
            
        default:
            break
        }
        return UITableViewCell.init()
    }
}

extension ChatViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        send()
        return true
    }
    
    func send(){
        if messageTextField.text != "" {
            sendMessage(text: messageTextField.text!, type: "text")
            messageTextField.text = ""
        }
        messageViewBottomConstrant.constant = -36
        messageTextField.endEditing(true)
    }
    
    
    func sendMessage(text:String,type:String) {
        if !isMap{
            isFirst = false
        }
        UserAPI.shard.sendMessage(to: driverId!, type: type, messageText: text, isFirst: isFirst, orderId: isFirst ? nil : orderId) { (status, messages, sendMessageData) in
            if status{
                if let message = sendMessageData{
                    DispatchQueue.main.async {
                        self.messages.append(message)
                        self.chatTableView.reloadData()
                        if !self.messages.isEmpty{
                            self.chatTableView.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                        }
                        if self.isFirst{
                            self.orderId = message.order_id!
                            self.isFirst = false
                        }
                    }
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
        }
    }
    
    private func addLeftPadding(textField:UITextField){
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12, height: textField.bounds.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
        
    }
}


extension ChatViewController: AVAudioRecorderDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}



extension ChatViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    private func setImageBy(source:UIImagePickerController.SourceType,mediaType:String){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        imagePicker.mediaTypes = [mediaType]
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker.mediaTypes == ["public.image"]{
            var userImage:UIImage?

            if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                userImage = editingImage
            }else if let orginalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                userImage = orginalImage
            }
            
            if let userImage = userImage{
                if !isMap{
                    isFirst = false
                }
                UserAPI.shard.sendFileMessage(image: userImage, url: nil, to: driverId, type: "image", isFirst: isFirst, orderId: isFirst ? nil : orderId) { (status, messages, chatData) in
                    if status{
                        DispatchQueue.main.async {
                            self.messages.append(chatData!)
                            self.chatTableView.reloadData()
                            if !self.messages.isEmpty{
                                self.chatTableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                            }
                            self.endAttachedAction()
                            self.dismiss(animated: true, completion: nil)
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
                }
            }
        }else{
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            if !isMap{
                isFirst = false
            }
            UserAPI.shard.sendFileMessage(image: nil, url: videoURL, to: driverId, type: "video", isFirst: isFirst, orderId: isFirst ? nil : orderId) { (status, messages, chatData) in
                if status{
                    DispatchQueue.main.async {
                        self.messages.append(chatData!)
                        self.chatTableView.reloadData()
                        if !self.messages.isEmpty{
                            self.chatTableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                        }
                        self.endAttachedAction()
                        self.dismiss(animated: true, completion: nil)
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
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}

extension ChatViewController:VideoMessageProtocol{
    func showPlayerVC(vc: AVPlayerViewController) {
        present(vc, animated: true)
    }
}

extension ChatViewController: CNContactPickerDelegate{
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
//        print("Contact Phone Number:: \(contact.phoneNumbers.first)")
    }
    
}
