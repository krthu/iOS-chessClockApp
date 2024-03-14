//
//  ViewController.swift
//  Clock
//
//  Created by Kristian Thun on 2024-03-09.
//

import UIKit

struct PlayerUiManager {
    
    let label : UILabel
    let player : Player
    let button : UIButton
    
    func timePassed() -> Bool{
        let timeIsUp = player.decreaseTime()
        updateTimeLabel()
        return timeIsUp
    }
    
    func moveIsMade(bonusSecodnsToAdd: Int){
        player.bonusSecondsTo(add: bonusSecodnsToAdd)
        updateTimeLabel()
    }
    
    func updateTimeLabel(){
        label.text = player.getTimeString()
    }
}

class ViewController: UIViewController {
    let toMenuSegueID = "toMenuSegueID"

    let formatter = DateFormatter()
    var timer : Timer?
    
    var gameTime = 5
    var bonusSecondsPerMove = 10
    
    var isPlayer1Active = false
    let player1 = Player(timeLeftInSeconds: 5 * 60)
    let player2 = Player(timeLeftInSeconds: 5 * 60)
    var player2Manager : PlayerUiManager? = nil
    var player1Manager : PlayerUiManager? = nil
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var menuButton: UIButton!

    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var player2Button: UIButton!
    
    @IBOutlet weak var player1Button: UIButton!
    @IBOutlet weak var player1Label: UILabel!
    
    @IBOutlet weak var pausButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player2Label.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        player2Manager = PlayerUiManager(label: player2Label, player: player2, button: player2Button)
        player1Manager = PlayerUiManager(label: player1Label, player: player1, button: player1Button)
        setupForNewGame()
        setupUIForNewGame()
        
        customizeButtons([menuButton])
        
    }
    
    func setupForNewGame(){
        player1Manager?.player.timeLeftInSeconds = gameTime * 60
        player2Manager?.player.timeLeftInSeconds = gameTime * 60
    }
    
    func middleButtons(){
        menuButton.layer.cornerRadius = 10
        menuButton.clipsToBounds = true
        
        pausButton.layer.cornerRadius = 10
        pausButton.clipsToBounds = true
        
        stopButton.layer.cornerRadius = 10
        pausButton.clipsToBounds = true
    }
    
    
    func setupUIForNewGame(){
        
        player1Manager?.label.text = player1Manager?.player.getTimeString()
        player2Manager?.label.text = player2Manager?.player.getTimeString()
        player1Manager?.button.isEnabled = true
        player2Manager?.button.isEnabled = true
        player1Manager?.label.textColor = .black
        player2Manager?.label.textColor = .black
        player1Manager?.button.backgroundColor = nil
        player2Manager?.button.backgroundColor = nil
        
        stopButton.isEnabled = false
        stopButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        pausButton.isEnabled = false
        menuButton.isEnabled = true
        
        menuButton.setTitle("\(gameTime):\(bonusSecondsPerMove)", for: .normal)
    }
    
    @IBAction func startClockButtonPressed(_ sender: UIButton) {
        menuButton.isEnabled = false
        pausButton.isEnabled = true
        stopButton.isEnabled = true
        
        if sender.tag == 1 {
            isPlayer1Active = false
            
        } else if sender.tag == 2{
            isPlayer1Active = true
        }
        
        if timer == nil {
            startClock()
        }else{
            sender.tag == 1 ? player1Manager?.moveIsMade(bonusSecodnsToAdd: bonusSecondsPerMove) : player2Manager?.moveIsMade(bonusSecodnsToAdd: bonusSecondsPerMove)
        }
        
        player1Button.isEnabled = isPlayer1Active
        player2Button.isEnabled = !isPlayer1Active
        
        player1Manager?.label.textColor = isPlayer1Active ? .black : .darkGray
        player2Manager?.label.textColor = !isPlayer1Active ? .black : .darkGray
    }
    
    func startClock(){
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block:updatePlayerTime(timer:))
            pausButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    
    @IBAction func pausButtonPress(_ sender: UIButton) {
        
        if timer == nil {
            startClock()
       
        } else{
            stopClock()
            timer = nil
            pausButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    var date = Date()
    func updatePlayerTime(timer: Timer? = nil){
        let newdate = Date()
    
        if isPlayer1Active {
            if let player1Manager = player1Manager{
                if !player1Manager.timePassed(){
                    print("Player 1 Lost")
                    
                    player1Manager.button.backgroundColor = .red
                    gameOver()
                    stopClock()
                }
            }
        }else{
            if let player2Manager = player2Manager {
                if !player2Manager.timePassed(){
                    print("Player 2 Lost")
                    
                    player2Manager.button.backgroundColor = .red
                    gameOver()
                    stopClock()
                }
            }

        let diff = newdate.timeIntervalSince(date)
        print(diff)
        date = newdate
        
    }
    
    
    func gameOver(){
        player1Manager?.button.isEnabled = false
        player2Manager?.button.isEnabled = false
        pausButton.isEnabled = false
        menuButton.isEnabled = true
        stopButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        
    }
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: toMenuSegueID , sender: self)
        
    }
    func stopClock(){
        timer?.invalidate()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toMenuSegueID {
            if let destinationVC = segue.destination as? MenuViewController{
                destinationVC.gameTime = gameTime
                destinationVC.extraTime = bonusSecondsPerMove
            }
        }
    }
    
    @IBAction func unwindToParentViewController(_ unwindSegue: UIStoryboardSegue) {
        if let fromVC = unwindSegue.source as? MenuViewController{
            if let newGameTime = fromVC.gameTime,
                let newExtraTime = fromVC.extraTime {
                gameTime = newGameTime
                bonusSecondsPerMove = newExtraTime
                setupForNewGame()
                setupUIForNewGame()
                print(gameTime)
            }
        }
    }
    
    @IBAction func stopButtonPress(_ sender: Any) {
        
        if player1Manager?.player.timeLeftInSeconds != 0 && player2Manager?.player.timeLeftInSeconds != 0 {
            
            let alertController = UIAlertController(title: "Stop Clock", message: "Do you want to end the game?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                self.stopClock()
                self.setupForNewGame()
                self.setupUIForNewGame()
            }
            let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action) in
                self.startClock()
            }
            cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
            okAction.setValue(UIColor.black, forKey: "titleTextColor")
           
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            
            present(alertController, animated: true)
        } else {
            setupForNewGame()
            setupUIForNewGame()
        }
        
    }

    
    deinit {
        stopClock()
    }
    
    func customizeButtons(_ buttons: [UIButton]){
        for button in buttons {
            button.setTitleColor(UIColor.lightGray, for: .disabled)
        }
    }
}

