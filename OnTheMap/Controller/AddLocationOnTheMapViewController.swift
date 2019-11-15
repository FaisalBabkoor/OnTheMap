//
//  AddLocationOnTheMapViewController.swift
//  OnTheMap
//
//  Created by Faisal Babkoor on 11/14/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit
import MapKit

class AddLocationOnTheMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var location: RequestStudentLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }
    @IBAction func finishButtonWasPressed(_ sender: UIButton) {
        guard let location = location else { return }
        MapClient.createNewStudentLocation(location: location) { (errorMessage) in
            if errorMessage == nil {
                
                self.dismiss(animated: true, completion: nil)
            }else {
                ShowAlert.showAlert(title: "Error", message: errorMessage!, vc: self)
            }
        }
    }
    
    private func setupMap() {
        guard let location = location else {
            ShowAlert.showAlert(title: "Error", message: "There is no location", vc: self)
            return
            
        }
        
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let mediaURL = location.mediaURL
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        annotation.subtitle = mediaURL
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let url = view.annotation?.subtitle else { return }
            if let websiteURL = URL(string: url!),
                UIApplication.shared.canOpenURL(websiteURL) {
                UIApplication.shared.open(websiteURL, options: [:])
            }
        }
    }
}

