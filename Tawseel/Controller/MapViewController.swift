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
    @IBOutlet var loactionLabel: UIView!
    @IBOutlet weak var saveLocationView: ViewDesignable!
    private let locationManager = CLLocationManager()
    private let googleMap = GMSMapView()
    private let marker = GMSMarker()
    private var userLocation:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    private func initlization() {
        checkLocationServices()
        setUpSaveLocationView()
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
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuth(status: locationManager.authorizationStatus)
        }else{
            showAlertView(title: "A problem in displaying the map", message: "You don't make premetion for location in your device to open the map")
        }
    }
    
    private func checkLocationAuth(status:CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:
            showAlertView(title:"You are denied this app to use GPS ", message: "If you want to use the map in this app, you have to change this app's permission in the settings")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            showAlertView(title: "You Don't have permetion for location", message: "You are restricted for access in location")
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    private func showAlertView(title:String,message:String){
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertC.addAction(.init(title: "Ok", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alertC, animated: true, completion: nil)
    }
    
    private func setupLocationManager() {
        googleMap.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    @IBAction func saveAction(_ sender: Any) {

    }
    
}
extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        showGoogleMap(withCoordinate: location.coordinate)
    }
    
    private func showGoogleMap(withCoordinate coordinate :CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 6)
        googleMap.frame = mapView.bounds
        googleMap.camera = camera
        mapView.addSubview(googleMap)
        marker.position = coordinate
        marker.iconView = UIImageView(image: #imageLiteral(resourceName: "userLocationImage"))
        marker.map = googleMap
    }
    
}

extension MapViewController:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        userLocation = coordinate
        marker.position = coordinate
    }
    
}
