//
//  TracingViewController.swift
//  Tawseel
//
//  Created by macbook on 19/03/2021.
//

import UIKit
import GoogleMaps
import Cosmos
class TracingViewController: UIViewController {
    @IBOutlet weak var mapView: UIViewCustomCornerRadius!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var invoiceNumLabel: UILabel!
    @IBOutlet weak var deliveryAmountLabel: UILabel!
    @IBOutlet weak var fromLocationLabel: UILabel!
    @IBOutlet weak var toLocationabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var completeDeliveryPopupView: UIView!
    @IBOutlet weak var ratingPopupView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var userRatingCommintTextField: UITextField!
    
    private var locationManager = CLLocationManager()
    private var googleMap = GMSMapView()
    private var invoicationData:InvoiceInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    @IBAction func addRatingAction(_ sender: Any) {
    }
    
    @IBAction func deliveredAction(_ sender: Any) {
    }
    
    @IBAction func noDeliveredAction(_ sender: Any) {
    }
    
    private func initlization(){
        setInvoicationData()
        showGoogleMap(fromImage: #imageLiteral(resourceName: "locationImage2"), toImage: #imageLiteral(resourceName: "locationImage2"), currentImage: #imageLiteral(resourceName: "locationIconImage"))
        setUpViews()
        userRatingCommintTextField.layer.masksToBounds = false
    }
    
    private func setUpViews(){
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidePopUp)))
        shadowView.isUserInteractionEnabled = true
    }
    
    @objc private func hidePopUp(){
        ratingPopupView.isHidden = true
        completeDeliveryPopupView.isHidden = true
        shadowView.isHidden = true
    }
    
    public func setLocations(invoctionInfo: InvoiceInfo){
        invoicationData = invoctionInfo
    }
    
    private func setInvoicationData(){
        userNameLabel.text = invoicationData.driverName
        invoiceNumLabel.text = invoicationData.invoiceNumber
        deliveryAmountLabel.text = invoicationData.deliveryAmount
        fromLocationLabel.text = invoicationData.fromLocation
        toLocationabel.text = invoicationData.toLocation
    }
    
    private func showAlertView(title:String,message:String){
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertC.addAction(.init(title: "Ok", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alertC, animated: true, completion: nil)
    }
    
    private func showGoogleMap(fromImage :UIImage,toImage :UIImage,currentImage :UIImage?) {
        
        if let from = invoicationData.fromLatLong , let to = invoicationData.toLatLong{
            
            let camera = GMSCameraPosition.camera(withLatitude: from.latitude, longitude: from.longitude, zoom: 6)
            // add google map view
            googleMap.frame = mapView.bounds
            googleMap.camera = camera
            mapView.addSubview(googleMap)
            
            // add Markers
            
            // add current driver marker if is not ended
            if let current = invoicationData.currentLatLong {
                let currentMarker = GMSMarker()
                currentMarker.position = current
                currentMarker.iconView = UIImageView(image: currentImage)
                currentMarker.map = googleMap
                
            }
            
            // add marker form first location
            let fromMarker = GMSMarker()
            fromMarker.position = from
            fromMarker.iconView = UIImageView(image: fromImage)
            fromMarker.map = googleMap
            
            // add marker to last location
            let toMarker = GMSMarker()
            toMarker.position = to
            toMarker.iconView = UIImageView(image: toImage)
            toMarker.map = googleMap
            
        }else{
            showAlertView(title: "Sorry!!", message: "An error occurred while getting the driver's path")
        }
    }
    
}
