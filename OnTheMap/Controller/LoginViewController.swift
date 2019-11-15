//
//  ViewController.swift
//  OnTheMap
//
//  Created by Faisal Babkoor on 11/14/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.stopAnimating()
        if UIDevice.current.orientation.isLandscape {
            subscribeToKeyboardNotifications()
        }    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if UIDevice.current.orientation.isLandscape {
            unsubscribeFromKeyboardNotifications()
        }
    }
    //
    @IBAction func loginButtonWasPressed(_ sender: UIButton) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        guard let email = emailTextField.text, email != "", let password = passwordTextField.text, password != "" else {
            ShowAlert.showAlert(title: "Missing email or password", message:  "Fill your email and password", vc: self)
            return
        }
        MapClient.crateSessionID(username: email, password: password) { (errorMessage) in
            DispatchQueue.main.async {
                if errorMessage != nil  {
                    ShowAlert.showAlert(title: "Error", message: errorMessage!, vc: self)
                    self.activityIndicator.stopAnimating()
                    return
                }
                self.performSegue(withIdentifier: Identifiers.SegueIdentifier.ToMapViewController, sender: nil)
                
            }
            
        }
        
    }
    
    @IBAction func singupButtonWasPressed(_ sender: UIButton) {
        if let websiteURL = URL(string: "https://auth.udacity.com/sign-up"),
            UIApplication.shared.canOpenURL(websiteURL) {
            UIApplication.shared.open(websiteURL, options: [:])
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.SegueIdentifier.ToMapViewController {
            if let destination = segue.destination as? MapViewController {
                destination.view.backgroundColor = .red
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
        if passwordTextField.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        if passwordTextField.isFirstResponder{
            view.frame.origin.y = 0.0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
