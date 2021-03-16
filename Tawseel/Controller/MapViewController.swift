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
    let locationManager = CLLocationManager()
    let googleMap = GMSMapView()
    let marker = GMSMarker()
    var userLocation:CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    func initlization() {
        checkLocationServices()
        setUpSaveLocationView()
    }
    func setUpSaveLocationView() {
        saveLocationView.layer.cornerRadius = 12
        saveLocationView.clipsToBounds = false
        saveLocationView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.13).cgColor
        saveLocationView.layer.shadowRadius = 8
        saveLocationView.layer.shadowOpacity = 1.0
        saveLocationView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }else{
//            print("You Don't Make premetion for Location in your device")
        }
    }
    func setupLocationManager() {
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
    
    func showGoogleMap(withCoordinate coordinate :CLLocationCoordinate2D) {
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
