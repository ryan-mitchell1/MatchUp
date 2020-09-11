//
//  ThirdViewController.swift
//  Assignment1
//
//  Created by Ryan Mitchell on 9/9/20.
//  Copyright © 2020 Ryan Mitchell. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var countDownDatePicker: UIDatePicker!
    @IBOutlet weak var outputLabel: UILabel!
    var timer: Timer?
    var timer2: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(self.updateTime), userInfo:nil, repeats: true)

        let diffComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: countDownDatePicker.date)
        let days = Int(diffComponents.day!)
        let hours = Int(diffComponents.hour!)
        let minutes = Int(diffComponents.minute!)
        let seconds = Int(diffComponents.second!)
        outputLabel.text = "There are \(days) days, \(hours) hours, \(minutes) minutes, and \(seconds) seconds until Christmas!"
    }
    @IBAction func changeDate(_ sender: Any) {
        timer?.invalidate()
        timer2 = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(self.updateChosenTime), userInfo:nil, repeats: true)
        let diffComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: countDownDatePicker.date)
        let days = Int(diffComponents.day!)
        let hours = Int(diffComponents.hour!)
        let minutes = Int(diffComponents.minute!)
        let seconds = Int(diffComponents.second!)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let stringInputDate = df.string(from: countDownDatePicker.date)
        if(stringInputDate == "2020-12-25"){
            outputLabel.text = "There are \(days) days, \(hours) hours, \(minutes) minutes, and \(seconds) seconds until Christmas!"
        }else{
            outputLabel.text = "There are \(days) days, \(hours) hours, \(minutes) minutes, and \(seconds) seconds until \(stringInputDate)."
        }
    }
    @objc func updateTime()
    {
        let diffComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: countDownDatePicker.date)
        var days = Int(diffComponents.day!)
        var hours = Int(diffComponents.hour!)
        var minutes = Int(diffComponents.minute!)
        var seconds = Int(diffComponents.second!)
        outputLabel.text = "There are \(days) days, \(hours) hours, \(minutes) minutes, and \(seconds) seconds until Christmas!"
        if(seconds == 0){
            minutes-=1
            if(minutes == 0){
                hours-=1
                if(hours == 0){
                    days-=1
                    hours = 23
                    minutes = 59
                    seconds = 60
                }
                minutes = 59
                seconds = 60
            }
            seconds = 60
        }
        seconds-=1
    }
    @objc func updateChosenTime()
    {
        let diffComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: countDownDatePicker.date)
        var days = Int(diffComponents.day!)
        var hours = Int(diffComponents.hour!)
        var minutes = Int(diffComponents.minute!)
        var seconds = Int(diffComponents.second!)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let stringInputDate = df.string(from: countDownDatePicker.date)
        if(stringInputDate == "2020-12-25"){
            outputLabel.text = "There are \(days) days, \(hours) hours, \(minutes) minutes, and \(seconds) seconds until Christmas!"
        }else{
            outputLabel.text = "There are \(days) days, \(hours) hours, \(minutes) minutes, and \(seconds) seconds until \(stringInputDate)."
        }
        if(seconds == 0){
            minutes-=1
            if(minutes == 0){
                hours-=1
                if(hours == 0){
                    days-=1
                    hours = 23
                    minutes = 59
                    seconds = 60
                }
                minutes = 59
                seconds = 60
            }
            seconds = 60
        }
        seconds-=1
    }
}
