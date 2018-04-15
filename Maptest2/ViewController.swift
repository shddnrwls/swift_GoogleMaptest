//
//  ViewController.swift
//  Maptest2
//
//  Created by mac on 2018. 2. 6..
//  Copyright © 2018년 swift. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,GMSAutocompleteViewControllerDelegate,UITableViewDelegate,UITableViewDataSource {
  
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager = CLLocationManager()

    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var googlemapcontainer: GMSMapView!
    var latitude = 0.1
    var longitude = 0.1
    var locationName = ""
    var parameter = ""
    var locationNamearr : Array<String> = Array<String>()
    let path = GMSMutablePath()
    


    
    
    
    override func viewDidLoad() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.stopUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        initGoogleMaps()
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
 
    func initGoogleMaps(){
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 9.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.googlemapcontainer.camera = camera
        self.googlemapcontainer.delegate = self
        self.googlemapcontainer.isMyLocationEnabled = true
        self.googlemapcontainer.settings.myLocationButton = true
        
        // Creates a marker in the center of the map.
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        
        
        marker.map = googlemapcontainer
        

        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error:\(error)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.googlemapcontainer.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.googlemapcontainer.isMyLocationEnabled = true
        
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.googlemapcontainer.isMyLocationEnabled = true
        if(gesture)
        {
            mapView.selectedMarker = nil
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        
        print ("위도 좌표:\(place.coordinate.latitude)")
        print ("경도 좌표:\(place.coordinate.longitude)")
       3
        self.googlemapcontainer.camera = camera
        self.dismiss(animated: true, completion: nil)
        
//        let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//        let marker = GMSMarker(position: position)
//        marker.title = place.name
//        marker.snippet = place.formattedAddress
//        marker.map = googlemapcontainer
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error:\(error)")
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationNamearr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = locationNamearr[indexPath.row]
        return cell!
        
        
    }
    @IBAction func openSearchAddress(_ sender: UIBarButtonItem) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    @IBAction func addBtn(_ sender: UIButton) {
        print(self.longitude)
        print(self.latitude)
//        locationLbl.text = self.locationName
        
        insertCell()
        let position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        let marker = GMSMarker(position: position)
        marker.map = googlemapcontainer
        path.add(CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude))
        let rectangle = GMSPolyline(path: path)
        rectangle.map = googlemapcontainer
    }
    func insertCell(){
        locationNamearr.append(self.locationName)
        let indexpath = IndexPath(row: locationNamearr.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexpath], with: .automatic)
        tableView.endUpdates()
        
    }
    @IBAction func testButton(_ sender: UIButton) {
        for i in locationNamearr
        {
            parameter += "list: [{city:\(i)}]"
            
        }
        print(parameter)
    }
}

 
