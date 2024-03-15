//
//  Player.swift
//  Clock
//
//  Created by Kristian Thun on 2024-03-12.
//

import Foundation
class Player {
    var timeLeftInSeconds: Int
    var timeLeftInSecondsDouble : Double
    
    init(timeLeftInSeconds: Int, timeLeftInSecondsDouble: Double) {
        self.timeLeftInSeconds = timeLeftInSeconds
        self.timeLeftInSecondsDouble = timeLeftInSecondsDouble
        
    }
    
//    func decreaseTime() -> Bool{
//        timeLeftInSeconds -= 1
//        if timeLeftInSeconds == 0 {
//            return false
//        } else {
//            return true
//        }
//    }
    
    func decreaseTime(elapsedTime: Double) -> Bool{
        timeLeftInSecondsDouble -= elapsedTime
        if timeLeftInSeconds <= 0 {
            return false
        } else {
            return true
        }
    }
    func bonusSecondsTo(add bonusTime: Int){
        
        timeLeftInSecondsDouble += Double(bonusTime)
    }
    

    func getTimeStringDouble() -> String{
        let roundedTimeLeft = timeLeftInSecondsDouble.rounded()
    
        let hours = Int(roundedTimeLeft / 3600)
        let minutes = Int(roundedTimeLeft.truncatingRemainder(dividingBy: 3600)/60)
        let secounds = Int(roundedTimeLeft.truncatingRemainder(dividingBy: 60))
        
        
  //      let time = Int(timeLeftInSecondsDouble)
        
//        let hours = time / 3600
//        let remainingTime = time % 3600
//        let minutes = remainingTime / 60
//        let secounds = remainingTime % 60
        if hours == 0 {
            return String(format: "%02d:%02d", minutes, secounds)
        }
        
        return String(format: "%02d:%02d:%02d", hours, minutes, secounds)
    }
    
    
//    func bonusSecondsTo(add bonusTime: Int){
//        timeLeftInSeconds += bonusTime
//    }
    
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
