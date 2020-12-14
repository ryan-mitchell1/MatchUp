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
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation
import FirebaseStorage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    struct User: Codable {
        let name: String
        let email: String
        let uid: String
        let description: String
        let desired: String
        let price: String
        let longitude: Float
        let latitude: Float
    }
    
    
    @IBOutlet weak var connectionsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var viewSearchAreaButton: UIButton!
    @IBOutlet weak var profileDataTableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    var i = 0;
    
    var profileArray:Array<String> = []
    var imageArray = [String : UIImage]()
    var userArray:Array<Array<String>> = []
    var currentLatitude:Float = 0.0
    var currentLongitude:Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        mapView.isHidden = true;

        locationManager.delegate = self

        locationManager.startUpdatingLocation()
        
        profileDataTableView.tableFooterView = UIView()
        
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [UIColor(red: 127/255, green: 223/255, blue: 255/255, alpha: 1.0).cgColor, UIColor(red: 1/255, green: 150/255, blue: 255/255, alpha: 1.0).cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        self.view.layer.insertSublayer(gradient, at: 0)
        profileDataTableView.backgroundColor = UIColor(red: 127/255, green: 223/255, blue: 255/255, alpha: 1.0)
        profileDataTableView.layer.cornerRadius = 10.0
        
        logoutButton.backgroundColor = UIColor(red: 1/255, green: 120/255, blue: 255/255, alpha: 1.0)
        logoutButton.tintColor = UIColor.white
        logoutButton.layer.cornerRadius = 10
        
        connectionsButton.backgroundColor = UIColor(red: 1/255, green: 120/255, blue: 255/255, alpha: 1.0)
        connectionsButton.tintColor = UIColor.white
        connectionsButton.layer.cornerRadius = 10

        
        yesButton.backgroundColor = UIColor(red: 229/255, green: 255/255, blue: 230/255, alpha: 1.0)
        yesButton.layer.cornerRadius = 5
        
        noButton.backgroundColor = UIColor(red: 255/255, green: 220/255, blue: 220/255, alpha: 1.0)
        noButton.layer.cornerRadius = 5
        
    }
    
    func readFromFirestore() -> Bool {
        var returnVal = true
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments { (snapshot, error) in
          if let error = error {
            returnVal = false
            print(error)
          } else if let snapshot = snapshot {
            let _: [User] = snapshot.documents.compactMap {
                let user = try? $0.data(as: User.self)
                self.profileArray = []
                self.profileArray.append("Name: \n" + user!.name)
                self.profileArray.append("User Description: \n" + user!.description)
                self.profileArray.append("Looking for: \n" + user!.desired)
                self.profileArray.append("Contact Email: \n" + user!.email)
                self.profileArray.append("Desired price point: \n" + user!.price)
                self.profileArray.append(user!.uid)
                let currentCoordinate = CLLocation(latitude: CLLocationDegrees(self.currentLatitude), longitude: CLLocationDegrees(self.currentLongitude))
                let profileCoordinate = CLLocation(latitude: CLLocationDegrees(user!.latitude), longitude: CLLocationDegrees(user!.longitude))
                
                let distanceInMeters = currentCoordinate.distance(from: profileCoordinate)
                if(distanceInMeters < 32187 && user!.uid != Auth.auth().currentUser!.uid){
                    let storageRef = Storage.storage().reference(withPath: "\(user!.uid)")
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                      if let error = error {
                        returnVal = false
                        print(error)
                        // Uh-oh, an error occurred!
                      } else {
                        // Data for "images/island.jpg" is returned
                        let image = UIImage(data: data!)
                        self.imageArray[user!.uid] = image
                      }
                    }
                    self.userArray.append(self.profileArray)
                }
              return user
            }
          }
        }
        print("retrieved data")
        return returnVal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let didRetrieveData = readFromFirestore()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if(!didRetrieveData) {
                print("Error has occured loading data")
            } else {
                print(self.userArray)
                print(self.profileArray)
                print(self.imageArray)
                self.profileArray = self.swipeFunctionality()!!
                self.profileDataTableView.reloadData()
                if(self.profileArray.count >= 5) {
                    self.imageView.image = self.imageArray[self.profileArray[5]]
                    self.imageArray.removeValue(forKey: self.profileArray[5])
                }
            }
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
                    try Auth.auth().signOut()
                }
             catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initial = storyboard.instantiateInitialViewController()
                UIApplication.shared.keyWindow?.rootViewController = initial
        
    }
    @IBAction func yesButtonTapped(_ sender: Any) {
        let managedObjectContainer = DatabaseController.managedObjectContainer()
        let connection = Connection(context: managedObjectContainer.viewContext)
        connection.name = profileArray[0]
        connection.userDesription = profileArray[1]
        connection.lookingFor = profileArray[2]
        connection.email = profileArray[3]
        connection.price = profileArray[4]
        DatabaseController.saveContext()
        
        profileArray = swipeFunctionality()!!
        profileDataTableView.reloadData()
        if(profileArray.count >= 5) {
            self.imageView.image = self.imageArray[self.profileArray[5]]
            self.imageArray.removeValue(forKey: self.profileArray[5])
        } else {
            self.imageView.image = UIImage(named: "NoUser")
        }
    }

    @IBAction func noButtonTapped(_ sender: Any) {
        profileArray = swipeFunctionality()!!
        profileDataTableView.reloadData()
        if(profileArray.count >= 5) {
            self.imageView.image = self.imageArray[self.profileArray[5]]
            self.imageArray.removeValue(forKey: self.profileArray[5])
        } else {
            self.imageView.image = UIImage(named: "NoUser")
        }
    }
    
    func swipeFunctionality() -> Array<String>?? {
        if(userArray.count > 0){
            return userArray.popLast()!
        } else {
            noButton.isEnabled = false
            yesButton.isEnabled = false
            return ["No more user available right now. Please try again later!"]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(profileArray.count == 1){
            return profileArray.count
        } else {
            return profileArray.count - 1   
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = profileArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = UIColor(red: 150/255, green: 230/255, blue: 255/255, alpha: 1.0)
        
        return cell
    }

    func addRadiusCircle(location: CLLocation){
        self.mapView.delegate = self
        let circle = MKCircle(center: location.coordinate, radius: 32187 as CLLocationDistance)
        self.mapView.addOverlay(circle)
    }
    
    @IBAction func viewSearchAreaButtonTapped(_ sender: Any) {
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
            self.currentLatitude = Float(currentLocation.coordinate.latitude)
            self.currentLongitude = Float(currentLocation.coordinate.longitude)
            addRadiusCircle(location: currentLocation)
            let mapRegion = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

            mapView.setRegion(mapRegion, animated: true)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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


