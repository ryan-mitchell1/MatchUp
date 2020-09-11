//
//  FirstViewController.swift
//  Assignment1
//
//  Created by Ryan Mitchell on 9/8/20.
//  Copyright © 2020 Ryan Mitchell. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    
    @IBOutlet weak var outputLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func concatTapped(_ sender: Any) {
        var displayString = ""
        if(firstNameField.text == "" || lastNameField.text == ""){
            displayString = "Please enter your first and last name."
        } else {
            displayString = "Hello \(firstNameField.text ?? "") \(lastNameField.text ?? ""), nice to meet you!"
        }
        outputLabel.text = displayString
    }
    
}

