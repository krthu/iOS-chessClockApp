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
    var isPlayer1Active = false
    

    
    @IBOutlet weak var player2Button: UIButton!
    
    @IBOutlet weak var player1Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.timeStyle = .medium
        player2Button.setTitle(getTimeString(toConvert: timeLeftPlayer2), for: .normal)
        player1Button.setTitle(getTimeString(toConvert: timeLeftPlayer1), for: .normal)
        
    }
    
    @IBAction func showClock(_ sender: UIButton) {
        
        if sender.tag == 1 {
            isPlayer1Active = false
            
        } else if sender.tag == 2{
            isPlayer1Active = true
            
        }
        player1Button.isEnabled = isPlayer1Active
        player2Button.isEnabled = !isPlayer1Active
        startClock()
       
        
    }
    
    func startClock(){
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block:updatePlayerTime(timer:))
        }
        
    }
    
    func updatePlayerTime(timer: Timer? = nil){
        
        if isPlayer1Active{
            timeLeftPlayer1 -= 1
            let timeFormated = getTimeString(toConvert: timeLeftPlayer1)
            player1Button.setTitle(timeFormated, for: .normal)
   
            
        } else{
            timeLeftPlayer2 -= 1
            let timeFormated = getTimeString(toConvert: timeLeftPlayer2)
            player2Button.setTitle(timeFormated, for: .normal)
        }
        if timeLeftPlayer1 == 0 || timeLeftPlayer2 == 0{
            timer?.invalidate()
        }

        
        
        
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

