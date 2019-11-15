//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Faisal Babkoor on 11/14/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit
import MapKit
class AddLocationViewController: UIViewController {
    
    @IBOutlet var locationNameTextField: UITextField!
    @IBOutlet var mediaLinkTextField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationNameTextField.delegate = self
        mediaLinkTextField.delegate = self
        MapClient.getPublicUserData(userId: Int(MapClient.AuthUser.key) ?? 0) { (userData, error) in
            guard error == nil else {
                ShowAlert.showAlert(title: "Error", message: error!.localizedDescription, vc: self)
                return
            }
            guard let user = userData else { return }
            MapClient.AuthUser.firstName = user.firstName ?? ""
            MapClient.AuthUser.firstName = user.lastName ?? ""
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.stopAnimating()
        if UIDevice.current.orientation.isLandscape {
            subscribeToKeyboardNotifications()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if UIDevice.current.orientation.isLandscape {
            unsubscribeFromKeyboardNotifications()
        }
    }
    @IBAction func cancelButtonWasPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func findLocationButtonWasPressed(_ sender: Any) {
        guard let location = locationNameTextField.text,
            let mediaLink = mediaLinkTextField.text,
            location != "", mediaLink != "" else {
                ShowAlert.showAlert(title: "Missing information", message: "Please fill fields", vc: self)
                return
        }
        activityIndicator.startAnimating()
        
        let sudentLocation = RequestStudentLocation(mapString: location, mediaURL: mediaLink)
        CLGeocoder().geocodeAddressString(sudentLocation.mapString!) { (placeMarks, err) in
            guard err == nil else {
                ShowAlert.showAlert(title: "Error", message: err!.localizedDescription, vc: self)
                self.activityIndicator.stopAnimating()
                return
                
            }
            self.activityIndicator.stopAnimating()
            guard let firstLocation = placeMarks?.first?.location else { return }
            var location = sudentLocation
            location.latitude = firstLocation.coordinate.latitude
            location.longitude = firstLocation.coordinate.longitude
            self.performSegue(withIdentifier: Identifiers.SegueIdentifier.ToAddLocatioOnTheMap, sender: location)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.SegueIdentifier.ToAddLocatioOnTheMap {
            if let addLocationOnTheMapVC = segue.destination as? AddLocationOnTheMapViewController {
                if let send = sender as? RequestStudentLocation {
                    addLocationOnTheMapVC.location = send
                }
            }
        }
    }
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardWillShow(_ notification: Notification){
        if mediaLinkTextField.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        if locationNameTextField.isFirstResponder{
            view.frame.origin.y = 0.0
        }
        if mediaLinkTextField.isFirstResponder{
            view.frame.origin.y = 0.0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
}

