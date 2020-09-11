//
//  FourthViewController.swift
//  Assignment1
//
//  Created by Ryan Mitchell on 9/9/20.
//  Copyright © 2020 Ryan Mitchell. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController {
    
    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var secondsTextField: UITextField!
    
    var clickCount = 0
    var countDownCount = 3
    var gameTime = 0
    var countTimer: Timer?
    var gameTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameButton.isEnabled = false
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if(secondsTextField.text == "" || secondsTextField.text == "0" || Int(secondsTextField.text!) == nil){
            outputLabel.text = "Please enter a valid game time, in seconds."
        } else {
            secondsTextField.isEnabled = false
            gameTime = Int(secondsTextField.text!)!
            startButton.isEnabled = false
            countTimer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(self.countDown), userInfo:nil, repeats: true)
            outputLabel.text = "Game is starting in 3."
        }
    }
    
    @objc func countDown(){
        if countDownCount != 0
        {
            countDownCount -= 1
            outputLabel.text = "Game is starting in \(countDownCount)."
        }
        else
        {
            gameButton.isEnabled = true
            countTimer!.invalidate()
            countDownCount = 3
            outputLabel.text = "Go!"
            gameTimer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(self.gameTimeCountDown), userInfo:nil, repeats: true)
        }
    }
    @IBAction func gameButtonTapped(_ sender: Any) {
        clickCount+=1
    }
    
    @objc func gameTimeCountDown() {
        if gameTime != 0 {
            gameTime -= 1
        } else {
            startButton.isEnabled = true
            gameTimer!.invalidate()
            gameButton.isEnabled = false
            outputLabel.text = "You clicked \(clickCount) times in \(Int(secondsTextField.text!)!) seconds!"
            clickCount = 0
            secondsTextField.isEnabled = true
        }
    }
}
