//
//  StartViewController.swift
//  Project 1
//
//  Created by Ryan Mitchell on 12/11/20.
//

import UIKit
import Firebase
import CoreLocation

class StartViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [UIColor(red: 127/255, green: 223/255, blue: 255/255, alpha: 1.0).cgColor, UIColor(red: 1/255, green: 150/255, blue: 255/255, alpha: 1.0).cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        self.view.layer.insertSublayer(gradient, at: 0)
        navigationController?.navigationBar.barTintColor = UIColor(red: 1/255, green: 150/255, blue: 255/255, alpha: 1.0)

        loginButton.backgroundColor = UIColor(red: 1/255, green: 120/255, blue: 255/255, alpha: 1.0)
        loginButton.tintColor = UIColor.white
        loginButton.layer.cornerRadius = 10
        
        signUpButton.backgroundColor = UIColor(red: 1/255, green: 120/255, blue: 255/255, alpha: 1.0)
        signUpButton.tintColor = UIColor.white
        signUpButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "startToHome", sender: nil)
        }
    }

    
    @IBAction func loginTapped(_ sender: Any) {
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
    @IBAction func signUpTapped(_ sender: Any) {
        performSegue(withIdentifier: "signUpSegue", sender: self)
    }
}
