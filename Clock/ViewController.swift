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
    
    @IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.timeStyle = .medium
    }
    

    
    @IBAction func showClock(_ sender: Any) {
        updateTime()
        startClock()
    }
    
    
    
    func startClock(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: updateTime(timer:))
        
    }
    
    func updateTime(timer: Timer? = nil){
        let date = Date()
        let dateString = formatter.string(from: date)
        counterLabel.text = dateString
    }
    
    func stopClock(){
        timer?.invalidate()
    }

    deinit {
        stopClock()
    }

}

