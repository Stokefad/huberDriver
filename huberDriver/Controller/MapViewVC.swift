//
//  MapViewVC.swift
//  huberDriver
//
//  Created by Igor-Macbook Pro on 20/01/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import FirebaseFirestore

class MapViewVC : UIViewController, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    @IBOutlet weak var sideBar: UIView!
    @IBOutlet weak var sideBarConstr: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var footer: UIView!
    @IBOutlet weak var bottomFooterConstr: NSLayoutConstraint!
    
    var currentDriver : String?
    var clientList : [Client] = [Client]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let button = UIButton(frame: CGRect(x: 10, y: 50, width: 70, height: 70))
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
        
        NotificationCenter.default.addObserver(self, selector: #selector(readCurrentUser(notification:)), name: Notification.Name(rawValue:
            "currentUser"), object: nil)
        
        sideBarConstr.constant = -240
        bottomFooterConstr.constant = -125
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: manager.location?.coordinate.latitude ?? 30, longitude: manager.location?.coordinate.longitude ?? 30), latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(sender:)))
        leftSwipe.direction = .left
        sideBar.addGestureRecognizer(leftSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(downSwipe(sender:)))
        downSwipe.direction = .down
        footer.addGestureRecognizer(downSwipe)
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(upSwipe(sender:)))
        upSwipe.direction = .up
        footer.addGestureRecognizer(upSwipe)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            saveCoords(latitude: location.coordinate.latitude, longtitude: location.coordinate.longitude)
        }
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    
    @IBAction func findButtonPressed(_ sender: UIButton) {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        setDriverOnline()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Gps failed with error \(error)")
    }
    
    
    @objc private func downSwipe(sender : UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self!.bottomFooterConstr.constant = -125
            self!.view.layoutIfNeeded()
        }
    }
    
    @objc private func upSwipe(sender : UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self!.bottomFooterConstr.constant = 0
            self!.view.layoutIfNeeded()
        }
    }
    
    @objc private func leftSwipe(sender : UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self!.sideBarConstr.constant = -240
            self!.view.layoutIfNeeded()
        }
    }
    
    @objc private func readCurrentUser(notification : Notification) {
        currentDriver = notification.userInfo!["email"] as? String
    }
    
    @objc private func buttonPressed(sender : UIButton) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self!.sideBarConstr.constant = 0
            self!.view.layoutIfNeeded()
        }
    }
    
    
    private func saveCoords(latitude : Double, longtitude : Double) {
        if let user = currentDriver {
            Firestore.firestore().collection("drivers").document(user).setData([
                "latitude" : latitude,
                "longtitude" : longtitude
            ], merge: true) { (error) in
                if error != nil {
                    print("Saving error occured \(String(describing: error))")
                }
            }
        }
    }
    
    private func retrieveClientsCoords() {
        Firestore.firestore().collection("users").filter(using: NSPredicate(format: "isOnline == true")).addSnapshotListener { [weak self] (snapshot, error) in
            if let documents = snapshot?.documents {
                for item in documents {
                    let client = Client()
                    
                    client.email = (item["email"] as? String)!
                    
                    self!.clientList.append(client)
                }
            }
        }
    }
    
    private func setDriverOnline() {
        if let driver = currentDriver {
            Firestore.firestore().collection("drivers").document(driver).setData([
                "isOnline" : true
            ])
        }
    }
    
}
