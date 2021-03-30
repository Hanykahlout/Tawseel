//
//  CenterMapViewController.swift
//  Tawseel
//
//  Created by macbook on 16/03/2021.
//

import UIKit
import GoogleMaps
import iOSDropDown
import SideMenu
class CenterMapViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityDD: DropDown!
    @IBOutlet weak var locationDD: DropDown!
    @IBOutlet weak var mapView: UIViewCustomCornerRadius!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var busyV: UIView!
    @IBOutlet weak var notAvailableV: UIView!
    @IBOutlet weak var shadowBlackV: UIView!
    @IBOutlet weak var beyound5Button: UIButton!
    @IBOutlet weak var closer5Button: UIButton!
    private var menu :SideMenuNavigationController?
    
    private let locationManager = CLLocationManager()
    private let googleMap = GMSMapView()
    private let marker = GMSMarker()
    private var markers = [GMSMarker]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    @IBAction func filterAction(_ sender: Any) {
        shadowBlackV.isHidden = !shadowBlackV.isHidden
        filterView.isHidden = !filterView.isHidden
    }
    
    @IBAction func menuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    @IBAction func beyond5KMAction(_ sender: Any) {
        beyound5Button.isSelected = !beyound5Button.isSelected
    }
    
    @IBAction func closer5KMAction(_ sender: Any) {
        closer5Button.isSelected = !closer5Button.isSelected
    }
    
    private func initlization() {
        setUpSideMenu()
        setUpDropDownMenu()
        setUpViews()
        showGoogleMap(withCoordinate: CLLocationCoordinate2D())
        checkLocationServices()
        getMarkersData()
    }
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    
    private func setUpDropDownMenu(){
        let text = try! String(contentsOfFile: Bundle.main.path(forResource: "world-cities", ofType: "txt")!)
        let lineArray = text.components(separatedBy: "\n")
        
        for eachLA in lineArray
        {
            let wordArray = eachLA.components(separatedBy: ",")
            cityDD.optionArray.append(wordArray[0])
        }
    }
    
    private func setUpViews() {
        shadowBlackV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setUpBlackView)))
        shadowBlackV.isUserInteractionEnabled = true
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
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    @objc private func  setUpBlackView(){
        shadowBlackV.isHidden = true
        filterView.isHidden = true
    }
    
}

extension CenterMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        googleMap.clear()
        showGoogleMap(withCoordinate: location.coordinate)
    }
    
    private func showGoogleMap(withCoordinate coordinate :CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 12)
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
