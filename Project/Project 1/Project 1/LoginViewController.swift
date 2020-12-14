//
//  LoginViewController.swift
//  Project 1
//
//  Created by Ryan Mitchell on 12/08/20.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        email.backgroundColor = UIColor.white
        password.backgroundColor = UIColor.white
        password.isSecureTextEntry = true
    }
    
    @IBAction func loginAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
           if error == nil{
             self.performSegue(withIdentifier: "loginToHome", sender: self)
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
