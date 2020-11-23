//
//  ViewController.swift
//  Project 1
//
//  Created by Ryan Mitchell on 10/27/20.
//

import UIKit
import CoreLocation
import MapKit
import CoreData


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //temp data
    let loggedInUserId = 1;
    let selectedCategoryName = "Board Games";
    //end of temp data
    
    
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var viewSearchAreaButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileDataTableView: UITableView!
    
    let imagePickerController = UIImagePickerController()

    let locationManager = CLLocationManager()
    
    var i = 0;
    
    var profileArray:Array<String> = []
    var userArray:Array<Array<String>> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isHidden = true;
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true

        locationManager.delegate = self

        locationManager.startUpdatingLocation()

        locationManager.requestWhenInUseAuthorization()
        
        profileDataTableView.tableFooterView = UIView()
        
        //adding temp user and category to test
        let managedObjectContainer = DatabaseController.managedObjectContainer()
        
        let category = Category(context: managedObjectContainer.viewContext)
        category.categoryName = "Board Games"
        category.categoryDescription = "Find others looking to play board games in your area. Swipe right to try to connect with the user or left to skip."
        
        let user = User(context: managedObjectContainer.viewContext)
        user.categoryName = "Board Games"
        user.latitude = 37.785834
        user.longitude = -122.406417
        user.userDescription = "I am looking to play board games with others in my area."
        user.name = "Ryan Mitchell"
        user.userId = 2
        //end of adding temp user and category
        
        let userFetchRequest:NSFetchRequest = User.fetchRequest()

        let fetchPredicate:NSPredicate = NSPredicate(format: "name CONTAINS %@", "Ryan Mitchell") //
        userFetchRequest.predicate = fetchPredicate

        do{
            let fetchResults = try managedObjectContainer.viewContext.fetch(userFetchRequest)
 
            if( fetchResults.count > 0 ){

                for user in fetchResults {
                    profileArray = []
                    profileArray.append("Name: \n" + user.name!)
                    profileArray.append("Category: \n" + user.categoryName!)
                    
                    let categoryFetchRequest:NSFetchRequest = Category.fetchRequest()

                    let fetchPredicate:NSPredicate = NSPredicate(format: "categoryName CONTAINS %@", user.categoryName!) //
                    categoryFetchRequest.predicate = fetchPredicate

                    do{
                        let fetchResults = try managedObjectContainer.viewContext.fetch(categoryFetchRequest)
             
                        if( fetchResults.count > 0 ){
                            let category = fetchResults[0]
                            profileArray.append("Category Description: \n" + category.categoryDescription!)
                        }
                        else{
                            print("no valid category")
                        }
                    }
                    catch{
                        print(exception.self)
                    }
                    profileArray.append("User Description: \n" + user.userDescription!)
                    profileArray.append("Click 'View Search Area' to see the area in which you may find others!")
                    userArray.append(profileArray)
                }
            }
            else{
                print("no valid users")
            }
        }
        catch{
            print(exception.self)
        }

        DatabaseController.saveContext()
        
        profileArray = swipeFunctionality()!!
    
    }
    
    //this will be replaced by the functionality of swipe action
    func swipeFunctionality() -> Array<String>?? {
        if(userArray.count > 0){
            return userArray.popLast()!
        } else {
            return nil
        }
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

    @IBAction func onConnectionsTap(_ sender: Any) {
        performSegue(withIdentifier: "ConnectionsSegue", sender: self)
    }
}


