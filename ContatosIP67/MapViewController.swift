//
//  MapViewController.swift
//  ContatosIP67
//
//  Created by ios6584 on 12/01/17.
//  Copyright © 2017 ios6584. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapKitView: MKMapView!
    
    private let locationManager = CLLocationManager()
    var contactDao: ContactDao!
    var contacts:Array<Contact>!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contactDao = ContactDao.currentInstance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.requestWhenInUseAuthorization()
        self.mapKitView.delegate = self
        
        let button = MKUserTrackingBarButtonItem(mapView: mapKitView)
        self.navigationItem.rightBarButtonItem = button
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contacts = self.contactDao.findAll()
        self.mapKitView.addAnnotations(contacts)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mapKitView.removeAnnotations(contacts)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinId = "pin"
        var pin = MKAnnotationView()
        if let reusablePin = self.mapKitView.dequeueReusableAnnotationView(withIdentifier: pinId) {
            pin = reusablePin
        } else {
            pin = MKAnnotationView(annotation: annotation, reuseIdentifier: pinId)
        }
        
        pin.canShowCallout = true
        
        let pinImage = #imageLiteral(resourceName: "gps")
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(size)
        pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedPinImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        pin.image = resizedPinImage
        
        if let contact = annotation as? Contact {
            if (contact.photo != nil) {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32.0, height: 32.0))
                imageView.layer.cornerRadius = 16.0
                imageView.clipsToBounds = true
                imageView.image = contact.photo
                pin.leftCalloutAccessoryView = imageView
            }
        }
        
        return pin
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
