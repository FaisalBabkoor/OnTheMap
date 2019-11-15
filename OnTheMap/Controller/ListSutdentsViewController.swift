//
//  ListSutdentsViewController.swift
//  OnTheMap
//
//  Created by Faisal Babkoor on 11/14/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit

class ListSutdentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var locations: [RequestStudentLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var locationsData: UsersInfo? {
        didSet {
            guard let locationsData = locationsData else { return }
            locations = locationsData.results
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        getData()
    }
    
    
    func getData() {
        MapClient.getStudentLocation { locations, error in
            guard let locations = locations else {
                ShowAlert.showAlert(title: "Error", message: error!.localizedDescription, vc: self)
                return
            }
            self.locations = locations.results
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.CellsIdentifier.ListSutdentsCell,for: indexPath)
        cell.textLabel?.text = locations[indexPath.row].firstName
        cell.detailTextLabel?.text = locations[indexPath.row].lastName
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = locations[indexPath.row].mediaURL else { return }
        if let websiteURL = URL(string: url),
            UIApplication.shared.canOpenURL(websiteURL) {
            UIApplication.shared.open(websiteURL, options: [:])
        }
    }
    @IBAction func addLocationButtonWasPressed(_ sender: Any) {
        if let navigationController = storyboard?.instantiateViewController(withIdentifier: Identifiers.StoryboardID.AddLocationNav) as? UINavigationController {
            present(navigationController, animated: true, completion: nil)
        }
    }
    @IBAction func refreshButtonWasPressed(_ sender: Any) {
        getData()
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
    
    
    
    
}

