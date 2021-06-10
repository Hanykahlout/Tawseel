//
//  CenterMapViewController.swift
//  Tawseel
//
//  Created by macbook on 16/03/2021.
//

import UIKit
import GoogleMaps
import SideMenu
import Cosmos
import MarqueeLabel
class CenterMapViewController: UIViewController {
    
    
    @IBOutlet weak var bannerTitleLabel: MarqueeLabel!
    
    @IBOutlet weak var newtworkAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingCancelStackView: UIStackView!
    @IBOutlet weak var okAlertButton: GraidentButton!
    
    
    @IBOutlet weak var mapView: UIViewCustomCornerRadius!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpMessageLabel: UILabel!
    @IBOutlet weak var shadowBlackV: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var fartherThan5Button: UIButton!
    @IBOutlet weak var closerThan5Button: UIButton!
    @IBOutlet weak var typeSelectionView: UIView!
    @IBOutlet weak var typeSelectionTableView: UITableView!
    
    
    private var selectionTypes = [(index:Int,text:String,isSelected:Bool)]()
    private var selectedType:(index:Int,text:String,isSelected:Bool)?
    private var drivers = [Driver]()
    private var menu :SideMenuNavigationController?
    private var currentLocation:CLLocationCoordinate2D?
    private let locationManager = CLLocationManager()
    private let googleMap = GMSMapView()
    private let userMarker = GMSMarker()
    private var currentDriver:Driver!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeSideMenuSide()
        getMarkersData()
    }
    
    
    private func initlization() {
        setUpBannerTitle()
        setUpHomeTabBar()
        setUpTableView()
        setSelectionTypes()
        setUpSideMenu()
        showGoogleMap(withCoordinate: CLLocationCoordinate2D())
        checkLocationServices()
        setUpViews()
    }
    
    
    private func setUpHomeTabBar(){
        tabBarController!.tabBar.items![0].title = NSLocalizedString("Home", comment: "")
        tabBarController!.tabBar.items![0].image = #imageLiteral(resourceName: "MainViewImage")
        tabBarController!.tabBar.items![0].selectedImage = #imageLiteral(resourceName: "MainViewImage")
        tabBarController!.tabBar.items![0].imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MarqueeLabel.controllerViewDidAppear(self)
    }
    
    private func setUpBannerTitle(){
    
        bannerTitleLabel.textAlignment = .left
        bannerTitleLabel.speed = .duration(5)
        bannerTitleLabel.fadeLength = 20.0
        bannerTitleLabel.leadingBuffer = 15.0
        bannerTitleLabel.text = NSLocalizedString("Click on the green icon to contact the driver", comment: "")
        
    }
    
    
    private func setSelectionTypes(){
        selectionTypes.append((index:0,text: NSLocalizedString("Taxi", comment: ""), isSelected: false))
        selectionTypes.append((index:1,text: NSLocalizedString("Delivery of restaurants and other orders", comment: ""), isSelected: false))
        selectionTypes.append((index:2,text: NSLocalizedString("Delivery of a gift in another city", comment: ""), isSelected: false))
        selectionTypes.append((index:3,text: NSLocalizedString("Delivery of shipments and goods", comment: ""), isSelected: false))
        selectionTypes.append((index:4,text: NSLocalizedString("Other", comment: ""), isSelected: false))
    }
    
    
    private func setUpTableView(){
        typeSelectionTableView.delegate = self
        typeSelectionTableView.dataSource = self
    }
    
    private func setUpSideMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu = SideMenuNavigationController(rootViewController: vc)
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    
    private func changeSideMenuSide(){
        if L102Language.currentAppleLanguage() == "ar"{
            bannerTitleLabel.type = .continuousReverse
            menu?.leftSide = true
            SideMenuManager.default.rightMenuNavigationController = nil
            SideMenuManager.default.leftMenuNavigationController = menu
        }else{
            bannerTitleLabel.type = .continuous
            menu?.leftSide = false
            SideMenuManager.default.leftMenuNavigationController = nil
            SideMenuManager.default.rightMenuNavigationController = menu
        }
    }
    
    
    private func setUpViews() {
        shadowBlackV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setUpBlackView)))
        shadowBlackV.isUserInteractionEnabled = true
        filterView.layer.masksToBounds = false
        popUpView.layer.masksToBounds = false
    }
    
    
    private func getMarkersData(){
        googleMap.clear()
        if let current = currentLocation{
            userMarker.position = current
            userMarker.iconView = UIImageView(image: #imageLiteral(resourceName: "userLocationImage"))
            userMarker.map = googleMap
        }
        UserAPI.shard.getAllDriver(lat: currentLocation != nil ? String(currentLocation!.latitude) : "" , lng: currentLocation != nil ? String(currentLocation!.longitude) : "") { (status, messages, drivers) in
            if status{
                if let drivers = drivers{
                    DispatchQueue.main.async {
                        self.drivers = drivers
                    }
                    for driver in drivers {
                        let marke = GMSMarker()
                        if let lat = driver.gpsLat , let lng = driver.gpsLng{
                            marke.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        }
                        switch driver.status {
                        case "off":
                            marke.iconView = UIImageView(image: #imageLiteral(resourceName: "redMarker"))
                            break
                        case "on":
                            marke.iconView = UIImageView(image: #imageLiteral(resourceName: "greenMarker"))
                            break
                        case "busey":
                            marke.iconView = UIImageView(image: #imageLiteral(resourceName: "grayMarker"))
                            break
                        default:
                            break
                        }
                        marke.map = self.googleMap
                    }
                }
            }else{
                
                GeneralActions.shard.monitorNetwork {
                    DispatchQueue.main.async {
                        self.settingCancelStackView.isHidden = true
                        self.okAlertButton.isHidden = false
                        
                        self.titleLabel.text = messages[0]
                        self.shadowBlackV.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                } notConectedAction: {
                    DispatchQueue.main.async {
                        self.settingCancelStackView.isHidden = true
                        self.okAlertButton.isHidden = false
                        self.titleLabel.text = NSLocalizedString("Make sure you have internet", comment: "")
                        self.shadowBlackV.isHidden = false
                        self.newtworkAlertView.isHidden = false
                    }
                }
            }
        }
        
    }
    
    private func getDriversMarkers(In drivers:[Driver]){
        for driver in drivers {
            let marke = GMSMarker()
            if let lat = driver.gpsLat , let lng = driver.gpsLng{
                marke.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            }
            switch driver.status {
            case "off":
                marke.iconView = UIImageView(image: #imageLiteral(resourceName: "redMarker"))
                break
            case "on":
                marke.iconView = UIImageView(image: #imageLiteral(resourceName: "greenMarker"))
                break
            case "busey":
                marke.iconView = UIImageView(image: #imageLiteral(resourceName: "grayMarker"))
                break
            default:
                break
            }
            marke.map = self.googleMap
        }
    }
    
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }else{
            DispatchQueue.main.async {
                self.titleLabel.text = NSLocalizedString("Make sure the location feature is enabled", comment: "")
                self.settingCancelStackView.isHidden = false
                self.okAlertButton.isHidden = true
                self.newtworkAlertView.isHidden = false
                self.shadowBlackV.isHidden = false
            }
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
    
    
    @objc private func setUpBlackView(){
        shadowBlackV.isHidden = true
        if !filterView.isHidden{
            if let currentLocation = currentLocation{
                UserAPI.shard.filterDrivers(location: currentLocation,stars: self.ratingView.rating,inside: closerThan5Button.isSelected) { (status, messages, drivers) in
                    if status{
                        if drivers!.isEmpty {
                            self.showAlert(title: NSLocalizedString("There are no drivers", comment: ""), message: NSLocalizedString("There are no drivers_Content", comment: ""))
                        }else{
                            DispatchQueue.main.async {
                                self.googleMap.clear()
                                self.showGoogleMap(withCoordinate: currentLocation)
                                self.drivers.removeAll()
                                self.drivers = drivers!
                                self.getDriversMarkers(In: drivers!)
                            }
                        }
                    }else{
                        GeneralActions.shard.monitorNetwork {
                            DispatchQueue.main.async {
                                self.settingCancelStackView.isHidden = true
                                self.okAlertButton.isHidden = false
                                self.titleLabel.text = messages[0]
                                self.shadowBlackV.isHidden = false
                                self.newtworkAlertView.isHidden = false
                            }
                        } notConectedAction: {
                            DispatchQueue.main.async {
                                self.settingCancelStackView.isHidden = true
                                self.okAlertButton.isHidden = false
                                self.titleLabel.text = NSLocalizedString("Make sure you have internet", comment: "")
                                self.shadowBlackV.isHidden = false
                                self.newtworkAlertView.isHidden = false
                            }
                        }
                    }
                }
            }
            ratingView.rating = 0.0
            filterView.isHidden = true
        }else if !popUpView.isHidden{
            popUpView.isHidden = true
        }else if !typeSelectionView.isHidden{
            typeSelectionView.isHidden = true
            if let selectedType = selectedType{
                selectionTypes[selectedType.index].isSelected = false
                self.selectedType = nil
                typeSelectionTableView.reloadData()
            }
        }else if !newtworkAlertView.isHidden{
            newtworkAlertView.isHidden = true
        }
    }
    
    
    private func showAlert(title:String,message:String){
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertC.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alertC, animated: true, completion: nil)
    }
    
    
    @IBAction func filterAction(_ sender: Any) {
        shadowBlackV.isHidden = !shadowBlackV.isHidden
        filterView.isHidden = !filterView.isHidden
    }
    
    
    @IBAction func menuAction(_ sender: Any) {
        present(menu!, animated: true, completion: nil)
    }
    
    
    
    @IBAction func insideDistanceAction(_ sender: Any) {
        fartherThan5Button.isSelected = closerThan5Button.isSelected
        closerThan5Button.isSelected = !fartherThan5Button.isSelected
    }
    
    
    @IBAction func outsideDistanceAction(_ sender: Any) {
        closerThan5Button.isSelected = fartherThan5Button.isSelected
        fartherThan5Button.isSelected = !closerThan5Button.isSelected
    }
    
    
    
    @IBAction func nextAction(_ sender: Any) {
        if let selectedType = selectedType{
            typeSelectionView.isHidden = true
            shadowBlackV.isHidden = true
            selectionTypes[selectedType.index].isSelected = false
            self.selectedType = nil
            typeSelectionTableView.reloadData()
            let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            vc.driverId = currentDriver.id!
            vc.isMap = true
            navigationController?.pushViewController(vc, animated: true)
            
        }else{
            GeneralActions.shard.showAlert(target: self, title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("You Should Choose Type Of Service", comment: ""))
        }
    }
    
    
    @IBAction func okNetworkAlertAction(_ sender: Any) {
        setUpBlackView()
    }
    
    @IBAction func setttingsAlertAction(_ sender: Any) {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
        
    }
    
    
    @IBAction func cancelAlertAction(_ sender: Any) {
        setUpBlackView()
    }
    
    
}

extension CenterMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        currentLocation = location.coordinate
        showGoogleMap(withCoordinate: location.coordinate)
        getMarkersData()
    }
    
    
    private func showGoogleMap(withCoordinate coordinate :CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 6)
        googleMap.frame = mapView.bounds
        googleMap.camera = camera
        mapView.addSubview(googleMap)
        
        userMarker.position = coordinate
        userMarker.iconView = UIImageView(image: #imageLiteral(resourceName: "userLocationImage"))
        userMarker.map = googleMap
    }
    
    
}

extension CenterMapViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        for driver in drivers {
            if let lat = driver.gpsLat , let long = driver.gpsLng{
                if marker.position.latitude == lat && marker.position.longitude == long{
                    currentDriver = driver
                    break
                }
            }
        }
        switch currentDriver.status {
        case "off":
            showPopUp(withMessage: NSLocalizedString("The delivery person is not available right now", comment: ""))
            
        case "busey":
            showPopUp(withMessage: NSLocalizedString("The delivery representative has a current request, you cannot contact him now", comment: ""))
            
        case "on":
            shadowBlackV.isHidden = false
            typeSelectionView.isHidden = false
        default:
            break
        }
        return true
    }
    
    private func showPopUp(withMessage message:String){
        popUpMessageLabel.text = message
        popUpView.isHidden = false
        shadowBlackV.isHidden = false
    }
    
}


extension CenterMapViewController:UITableViewDelegate,UITableViewDataSource,SelectionType{
    func select(indexPath: IndexPath) {
        changeSelectedMethod(indexPath: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectionTypes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeSelectionTableViewCell", for: indexPath) as! TypeSelectionTableViewCell
        cell.setData(typeData: selectionTypes[indexPath.row])
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeSelectedMethod(indexPath: indexPath)
    }
    
    private func changeSelectedMethod(indexPath:IndexPath){
        if !selectionTypes[indexPath.row].isSelected {
            selectionTypes[indexPath.row].isSelected = true
            selectedType = selectionTypes[indexPath.row]
            for index in 0..<selectionTypes.count{
                if selectionTypes[index].isSelected && selectionTypes[index].text != selectionTypes[indexPath.row].text {
                    selectionTypes[index].isSelected = false
                }
            }
            typeSelectionTableView.reloadData()
        }
    }
}

extension UILabel {
    func animation(typing value: String, duration: Double){
        for char in value {
            self.text?.append(char)
            RunLoop.current.run(until: Date() + duration)
        }
    }
}

