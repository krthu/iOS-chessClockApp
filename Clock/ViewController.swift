//
//  ViewController.swift
//  Clock
//
//  Created by Kristian Thun on 2024-03-09.
//

import UIKit

class ViewController: UIViewController {


    let formatter = DateFormatter()
    var timer : Timer?
    
    var gameTime = 5
    
    var timeLeftPlayer1 = 5 * 60
    var timeLeftPlayer2 = 5 * 60
    
    @IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.timeStyle = .medium
        counterLabel.text = getTimeString(toConvert: timeLeftPlayer1)
        
    }
    

    
    @IBAction func showClock(_ sender: Any) {
        //updateTime()
        startClock()
    }
    
    func startClock(){
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updatePlayerTime(timer:))
            
        }
    }
    
    func updateTime(timer: Timer? = nil){
        let date = Date()
        let dateString = formatter.string(from: date)
        counterLabel.text = dateString
    }
    
    func updatePlayerTime(timer: Timer? = nil){
        timeLeftPlayer1 -= 1
        let timeFormated = getTimeString(toConvert: timeLeftPlayer1)
        counterLabel.text = String(timeFormated)
    }
    
    func stopClock(){
        timer?.invalidate()
    }
    
    func getTimeString(toConvert: Int) -> String{
        let hours = toConvert / 3600
        let remainingTime = toConvert % 3600
        let minutes = remainingTime / 60
        let secounds = remainingTime % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secounds)
    
        
    }

    deinit {
        stopClock()
    }

}

