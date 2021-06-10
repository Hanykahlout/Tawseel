//
//  TracingViewController.swift
//  Tawseel
//
//  Created by macbook on 19/03/2021.
//

import UIKit
import GoogleMaps
class TracingViewController: UIViewController {
    
    @IBOutlet weak var mapView: UIViewCustomCornerRadius!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var deliveryAmountLabel: UILabel!
    @IBOutlet weak var fromLocationLabel: UILabel!
    @IBOutlet weak var toLocationabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    private var locationManager = CLLocationManager()
    private var googleMap = GMSMapView()
    public var orderData:Order!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.setImage( L102Language.currentAppleLanguage() == "ar" ? #imageLiteral(resourceName: "front") : #imageLiteral(resourceName: "back"), for: .normal)
        setOrderData()
    }
    
    
    private func setOrderData(){
        userNameLabel.text = orderData.iDName
        orderNumLabel.text = orderData.bill_id ?? ""
        deliveryAmountLabel.text = "\(orderData.price ?? -1) \(NSLocalizedString("SR",comment: ""))"
        fromLocationLabel.text = orderData.from_address
        toLocationabel.text = orderData.to_address
        showGoogleMap(fromImage: #imageLiteral(resourceName: "locationImage2"), toImage: #imageLiteral(resourceName: "locationImage2"), currentImage: #imageLiteral(resourceName: "locationIconImage"))
        
    }
    
    
    private func showAlertView(title:String,message:String){
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertC.addAction(.init(title: "Ok", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alertC, animated: true, completion: nil)
    }
    
    
    private func showGoogleMap(fromImage :UIImage,toImage :UIImage,currentImage :UIImage?) {
        
        if let fromLat = orderData.from_lat ,
           let toLat = orderData.to_lat ,
           let fromLong = orderData.from_lng ,
           let toLong = orderData.to_lng
        {
            
            let camera = GMSCameraPosition.camera(withLatitude: fromLat, longitude: fromLong, zoom: 6)
            // add google map view
            googleMap.frame = mapView.bounds
            googleMap.camera = camera
            mapView.addSubview(googleMap)
            
            // add Markers
            if let currentLat = orderData.current_lat,
               let currentLong = orderData.current_lng{
                // add current driver marker if is not ended
                let currentMarker = GMSMarker()
                currentMarker.position = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong)
                currentMarker.iconView = UIImageView(image: currentImage)
                currentMarker.map = googleMap
            }

            // add marker form first location
            let fromMarker = GMSMarker()
            fromMarker.position = CLLocationCoordinate2D(latitude: fromLat, longitude: fromLong)
            fromMarker.iconView = UIImageView(image: fromImage)
            fromMarker.map = googleMap
            
            // add marker to last location
            let toMarker = GMSMarker()
            toMarker.position = CLLocationCoordinate2D(latitude: toLat, longitude: toLong)
            toMarker.iconView = UIImageView(image: toImage)
            toMarker.map = googleMap
        
        }else{
            showAlertView(title: NSLocalizedString("Sorry!!", comment: ""), message: NSLocalizedString("An error occurred while getting the driver's path", comment: ""))
        }
    }
    
    
    @IBAction func addRatingAction(_ sender: Any) {
        
    }
    
    
    @IBAction func deliveredAction(_ sender: Any) {
        
    }
    
    
    @IBAction func noDeliveredAction(_ sender: Any) {
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

