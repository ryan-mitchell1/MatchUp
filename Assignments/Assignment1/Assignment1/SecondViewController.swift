//
//  SecondViewController.swift
//  Assignment1
//
//  Created by Ryan Mitchell on 9/8/20.
//  Copyright © 2020 Ryan Mitchell. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var numTwoTextBox: UITextField!
    @IBOutlet weak var numOneTextBox: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var operatorTextBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    
    var list = ["+", "-", "*", "%"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDown.delegate = self
        dropDown.dataSource = self
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

        return list.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        self.view.endEditing(true)
        return list[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        self.operatorTextBox.text = self.list[row]
        self.dropDown.isHidden = true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == self.operatorTextBox {
            self.dropDown.isHidden = false

            textField.endEditing(true)
        }
    }

    @IBAction func caclulateButtonClick(_ sender: Any) {
        if(numOneTextBox.text != "" && numTwoTextBox.text != "" && list[dropDown.selectedRow(inComponent:0)] != ""){
            let firstNum = Int(numOneTextBox.text!)
            let secondNum = Int(numTwoTextBox.text!)
            let selectedOperator = list[dropDown.selectedRow(inComponent:0)]
            var result = 0
            if(selectedOperator == "-"){
                result = firstNum! - secondNum!
            } else if(selectedOperator == "+"){
                result = firstNum! + secondNum!
            } else if(selectedOperator == "*"){
                result = firstNum! * secondNum!
            } else{
                result = firstNum! / secondNum!
            }
            outputLabel.text = "\(numOneTextBox.text ?? "First Number") \(selectedOperator) \(numTwoTextBox.text ?? "Second Number") = \(result)"
        } else {
            outputLabel.text = "Please enter/select all three values"
        }
    }
}

