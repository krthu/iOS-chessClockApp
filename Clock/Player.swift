//
//  Player.swift
//  Clock
//
//  Created by Kristian Thun on 2024-03-12.
//

import Foundation
class Player {

    var timeLeftInSecondsDouble : Double
    
    init(timeLeftInSecondsDouble: Double) {

        self.timeLeftInSecondsDouble = timeLeftInSecondsDouble
        
    }
    
    func decreaseTime(elapsedTime: Double) -> Bool{
        timeLeftInSecondsDouble -= elapsedTime
        if timeLeftInSecondsDouble <= 0 {
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
        
        if hours == 0 {
            return String(format: "%02d:%02d", minutes, secounds)
        }
        
        return String(format: "%02d:%02d:%02d", hours, minutes, secounds)
    }
    
}
