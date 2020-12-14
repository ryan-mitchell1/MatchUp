//
//  SignUpViewController.swift
//  Project 1
//
//  Created by Ryan Mitchell on 12/08/20.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation
import FirebaseStorage

class SignUpViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let locationManager = CLLocationManager()
    let imagePickerController = UIImagePickerController()

    
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
    
    var currentLatitude:Float = 0.0
    var currentLongitude:Float = 0.0
    var choosenImage:UIImage? = nil
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var profileDesc: UITextField!
    @IBOutlet weak var desired: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self

        locationManager.startUpdatingLocation()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [UIColor(red: 127/255, green: 223/255, blue: 255/255, alpha: 1.0).cgColor, UIColor(red: 1/255, green: 150/255, blue: 255/255, alpha: 1.0).cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        self.view.layer.insertSublayer(gradient, at: 0)
        navigationController?.navigationBar.barTintColor = UIColor(red: 1/255, green: 150/255, blue: 255/255, alpha: 1.0)
        
        signUpButton.backgroundColor = UIColor(red: 1/255, green: 120/255, blue: 255/255, alpha: 1.0)
        signUpButton.tintColor = UIColor.white
        signUpButton.layer.cornerRadius = 10
        
        email.backgroundColor = UIColor.white
        password.backgroundColor = UIColor.white
        name.backgroundColor = UIColor.white
        profileDesc.backgroundColor = UIColor.white
        desired.backgroundColor = UIColor.white
        price.backgroundColor = UIColor.white
        
    }
    

    @IBAction func choosePictureTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Choose a profile photo", message: "Choose from your library or camera to select a profile photo to use in your new account.", preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (alertAction) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))

        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alertAction) in
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
    
    @IBAction func signUpAction(_ sender: Any) {
        if(name.text! == "" || profileDesc.text! == "" || desired.text! == "" || price.text! == ""){
            let alertController = UIAlertController(title: "Error", message: "All feilds must be filled in!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                             
             alertController.addAction(defaultAction)
             self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
             if error == nil {
                let didAddItem = self.addItem()
                if(didAddItem == true){
                    let didUploadImage = self.uploadImage()
                    if(didUploadImage == true){
                        self.performSegue(withIdentifier: "signUpToHome", sender: self)
                    } else {
                        let alertController = UIAlertController(title: "Error", message: "Error uploading image", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                        
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
             }
             else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func addItem() -> Bool {
      let db = Firestore.firestore() // 1
        let user = User(name: name.text!, email: email.text!, uid: Auth.auth().currentUser!.uid, description: profileDesc.text!, desired: desired.text!, price: price.text!, longitude: currentLongitude, latitude: currentLatitude)
      do { // 2
        try db.collection("users").document().setData(from: user)
      } catch {
        print("failed to add user to database")
        return false
      }
        return true
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first{
            currentLatitude = Float(currentLocation.coordinate.latitude)
            currentLongitude = Float(currentLocation.coordinate.longitude)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        choosenImage = info[.editedImage] as? UIImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage() -> Bool {
        guard let imageData: Data = choosenImage!.jpegData(compressionQuality: 0.8) else {
                return false
            }

        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let filePath = "\(Auth.auth().currentUser!.uid)"

        let storageRef = Storage.storage().reference(withPath: filePath)

        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                print(error.localizedDescription)

                return
            }

            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                print(url?.absoluteString) // <- Download URL
            })
        }
        return true
    }
}
