//
//  MapViewController.swift
//  Tawseel
//
//  Created by macbook on 15/03/2021.
//

import UIKit
import GoogleMaps
class MapViewController: UIViewController {
    
    
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet weak var saveLocationView: ViewDesignable!
    
    private let locationManager = CLLocationManager()
    private let googleMap = GMSMapView()
    private let marker = GMSMarker()
    private var userLocation:CLLocationCoordinate2D?
    public var isFromBills = false
    public var selectedLocation:CLLocationCoordinate2D?
    public var selectedLocationAddress:String = NSLocalizedString("Location", comment: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    
    private func initlization() {
        showGoogleMap(withCoordinate: CLLocationCoordinate2D())
        checkLocationServices()
        setUpSaveLocationView()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedLocation = selectedLocation{
            showGoogleMap(withCoordinate: selectedLocation)
            locationLabel.text = selectedLocationAddress
        }
    }
    
    
    private func setUpSaveLocationView() {
        saveLocationView.layer.cornerRadius = 12
        saveLocationView.clipsToBounds = false
        saveLocationView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.13).cgColor
        saveLocationView.layer.shadowRadius = 8
        saveLocationView.layer.shadowOpacity = 1.0
        saveLocationView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    
    private func checkLocationServices() {
        setupLocationManager()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    
    private func setupLocationManager() {
        googleMap.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    private func getAddressFromCoordinate(currentLocation:CLLocationCoordinate2D){
        GMSGeocoder.init().reverseGeocodeCoordinate(currentLocation) { (response, error) in
            if error != nil{
                return
            }
            if let response = response {
                let result = response.firstResult()?.thoroughfare ?? NSLocalizedString("location not determined", comment: "")
                self.locationLabel.text = result
            }
        }
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        var user = UserDefaultsData.shard.getUser()
        user.gpsLat = marker.position.latitude
        user.gpsLng = marker.position.longitude
        UserDefaultsData.shard.saveUser(user: user)
        navigationController?.popViewController(animated: true)
    }
}


extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isFromBills{
            guard let location = locations.first else { return }
            self.getAddressFromCoordinate(currentLocation: location.coordinate)
            showGoogleMap(withCoordinate: location.coordinate)
        }
    }
    
    
    private func showGoogleMap(withCoordinate coordinate :CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 6)
        googleMap.frame = mapView.bounds
        googleMap.camera = camera
        mapView.addSubview(googleMap)
        marker.position = coordinate
        marker.iconView = UIImageView(image: isFromBills ? #imageLiteral(resourceName: "locationImage2") : #imageLiteral(resourceName: "userLocationImage"))
        marker.map = googleMap
    }
    
}

extension MapViewController:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if !isFromBills{
            self.getAddressFromCoordinate(currentLocation: coordinate)
            marker.position = coordinate
        }
    }
    
}


