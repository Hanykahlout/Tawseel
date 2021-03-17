//
//  CenterMapViewController.swift
//  Tawseel
//
//  Created by macbook on 16/03/2021.
//

import UIKit
import GoogleMaps
class CenterMapViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapView: UIViewCustomCornerRadius!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var busyV: UIView!
    @IBOutlet weak var notAvailableV: UIView!
    @IBOutlet weak var shadowBlackV: UIView!
    private let locationManager = CLLocationManager()
    private let googleMap = GMSMapView()
    private let marker = GMSMarker()
    private var markers = [GMSMarker]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    @IBAction func filterAction(_ sender: Any) {
    }
    
    @IBAction func menuAction(_ sender: Any) {
    }
    
    private func initlization() {
        setUpViews()
        setupLocationManager()
        getMarkersData()
    }
    
    private func setUpViews() {
        filterView.layer.masksToBounds = false
        busyV.layer.masksToBounds = false
        notAvailableV.layer.masksToBounds = false
    }
    
    private func  getMarkersData(){
        markers.append(GMSMarker(position: .init(latitude: 52.768525569424426, longitude:  -2.6532314345240597)))
        markers.append(GMSMarker(position: .init(latitude: 49.9524978757854, longitude:  2.2320230305194855)))
        markers.append(GMSMarker(position: .init(latitude: 49.9524978757854, longitude:  2.2320230305194855)))
        markers.append(GMSMarker(position: .init(latitude: 47.47400539089738, longitude:  1.2579017132520676)))
        markers.append(GMSMarker(position: .init(latitude: 46.55518907759977 , longitude:  3.0523350834846497)))
        markers.append(GMSMarker(position: .init(latitude: 49.66417309799187 , longitude:  3.6968668922781944)))
        markers.append(GMSMarker(position: .init(latitude: 50.43078317771081, longitude:  2.6348549500107765)))
        markers.append(GMSMarker(position: .init(latitude: 52.31417086216214, longitude:  0.7745032757520677)))
    }
    
    private func setupLocationManager() {
        locationManager.startUpdatingLocation()
        googleMap.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
}

extension CenterMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
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
        for m in markers {
            m.iconView = UIImageView(image: #imageLiteral(resourceName: "greenMarker"))
            m.map = googleMap
        }
    }
}

extension CenterMapViewController: GMSMapViewDelegate{
    
}
