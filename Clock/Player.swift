//
//  Player.swift
//  Clock
//
//  Created by Kristian Thun on 2024-03-12.
//

import Foundation
class Player {
    var timeLeftInSeconds: Int
    
    init(timeLeftInSeconds: Int) {
        self.timeLeftInSeconds = timeLeftInSeconds
    }
    
    func decreaseTime() -> Bool{
        timeLeftInSeconds -= 1
        if timeLeftInSeconds == 0 {
            return false
        } else {
            return true
        }
    }
    
    func bonusSecondsTo(add bonusTime: Int){
        timeLeftInSeconds += bonusTime
    }
    
    func getTimeString() -> String{
        let hours = timeLeftInSeconds / 3600
        let remainingTime = timeLeftInSeconds % 3600
        let minutes = remainingTime / 60
        let secounds = remainingTime % 60
        if hours == 0 {
            return String(format: "%02d:%02d", minutes, secounds)
        }
        
        return String(format: "%02d:%02d:%02d", hours, minutes, secounds)
    }
    
}
