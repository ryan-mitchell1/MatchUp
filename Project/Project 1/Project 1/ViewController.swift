//
//  ViewController.swift
//  Project 1
//
//  Created by Ryan Mitchell on 10/27/20.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var viewSearchAreaButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileDataTableView: UITableView!
    
    let imagePickerController = UIImagePickerController()

    let locationManager = CLLocationManager()
    
    var i = 0;
    
    var profileArray:Array<String> = ["Name: \nRyan Mitchell", "Category: \nBoard Games", "Category Description: \nFind others looking to play board games in your area. Swipe right to try to connect with the user or left to skip.", "User Description: \nI am looking to play board games with others in my area.", "Click 'View Search Area' to see the area in which you may find others!"]

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isHidden = true;
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true

        locationManager.delegate = self

        locationManager.startUpdatingLocation()

        locationManager.requestWhenInUseAuthorization()
        
        profileDataTableView.tableFooterView = UIView()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = profileArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }

    func addRadiusCircle(location: CLLocation){
        self.mapView.delegate = self
        let circle = MKCircle(center: location.coordinate, radius: 1000 as CLLocationDistance)
        self.mapView.addOverlay(circle)
    }
    
    @IBAction func tapViewSearchAreaButton(_ sender: Any) {
        if i%2 == 0{
            viewSearchAreaButton.setTitle("Close Search Area", for: .normal)
            mapView.isHidden = false
            contentTableView.isHidden = true
        } else {
            viewSearchAreaButton.setTitle("View Search Area", for: .normal)
            mapView.isHidden = true
            contentTableView.isHidden = false
        }
        i = i+1
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first{
            print(currentLocation.coordinate)
            addRadiusCircle(location: currentLocation)
            let mapRegion = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

            mapView.setRegion(mapRegion, animated: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let alertController = UIAlertController(title: "Choose a profile photo", message: "Choose from your library or camera to select a profile photo to use in your new account.", preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (alertAction) in
            print("library")
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))

        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alertAction) in
            print("camera")
            if( UIImagePickerController.isSourceTypeAvailable(.camera) ){
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
            print("cancel")
        }))

        present(alertController, animated: true, completion: nil)
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choosenImage = info[.editedImage] as! UIImage

        imageView.image = choosenImage

        dismiss(animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = UIColor.red
        circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
        circle.lineWidth = 1
        return circle
    }

}


