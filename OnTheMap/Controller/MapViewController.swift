//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Faisal Babkoor on 11/14/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStudentLocation()
        mapView.delegate = self
        
    }
    
    @IBAction func addLocationButtonWasPressed(_ sender: Any) {
        if let navigationController = storyboard?.instantiateViewController(withIdentifier: Identifiers.StoryboardID.AddLocationNav) as? UINavigationController {
            present(navigationController, animated: true, completion: nil)
        }
    }
    @IBAction func refreshButtonWasPressed(_ sender: Any) {
        getStudentLocation()
    }
    
    @IBAction func logouButtonWasPressed(_ sender: Any) {
        MapClient.logout { (success, error) in
            if success {
                self.dismiss(animated: true)
            } else {
                ShowAlert.showAlert(title: "Error", message: error!.localizedDescription, vc: self)
            }
        }
    }
    
    func getStudentLocation() {
        MapClient.getStudentLocation { locations, error in
            guard let locations = locations else {
                ShowAlert.showAlert(title: "Error", message: error!.localizedDescription, vc: self)
                return
            }
            var annotations = [MKPointAnnotation]()
            for location in locations.results {
                guard let latitude = location.latitude, let longitude = location.longitude else { continue }
                
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let first = location.firstName
                let last = location.lastName
                let mediaURL = location.mediaURL
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first ?? "") \(last ?? "")"
                annotation.subtitle = mediaURL
                annotations.append(annotation)
            }
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
        }
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
