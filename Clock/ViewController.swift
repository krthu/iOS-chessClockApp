//
//  ViewController.swift
//  Clock
//
//  Created by Kristian Thun on 2024-03-09.
//

import UIKit

struct PlayerUiManager {
    
    let timeLabel : UILabel
    let player : Player
    let button : UIButton
    let extraTimeLabel: UILabel
    
    func timePassed(elapsedTime: Double) -> Bool{
        let timeIsUp = player.decreaseTime(elapsedTime: elapsedTime)
        updateTimeLabel()
      
        return timeIsUp
    }
    
    func moveIsMade(bonusSecodnsToAdd: Int){
        player.bonusSecondsTo(add: bonusSecodnsToAdd)
        extraTimeLabel.text = "+\(bonusSecodnsToAdd)"
        fadeInExtraTime()
        updateTimeLabel()
    }
    
    func updateTimeLabel(){
        timeLabel.text = player.getTimeStringDouble()
    }
    
    func updateUiForNewGame(){
        timeLabel.text = player.getTimeStringDouble()
        timeLabel.textColor = .black
        button.isEnabled = true
        button.backgroundColor = nil
    }
    
    func fadeInExtraTime(){
        print("Fade IN ")
        UIView.animate(withDuration: 0.5, animations: {
            extraTimeLabel.alpha = 1
        }) 
        { (finished) in
            UIView.animate(withDuration: 0.5, delay: 1, options: [], animations: {
                extraTimeLabel.alpha = 0
            })
        }
        
    }
}

class ViewController: UIViewController {
    let toMenuSegueID = "toMenuSegueID"

    let formatter = DateFormatter()
    var timer : Timer?
    
    var gameTime = 5.0
    var bonusSecondsPerMove = 10
    var time = Date().timeIntervalSince1970
    
    var isPlayer1Active = false

    var player2Manager : PlayerUiManager? = nil
    var player1Manager : PlayerUiManager? = nil
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var pausButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!

    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var player2Button: UIButton!
    @IBOutlet weak var player2ExtraTimeLabel: UILabel!
    

    @IBOutlet weak var player1Button: UIButton!
    @IBOutlet weak var player1Label: UILabel!
    
    @IBOutlet weak var player1ExtraTimeLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player2Label.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        player2ExtraTimeLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)

        player2Manager = PlayerUiManager(timeLabel: player2Label, player: Player(timeLeftInSecondsDouble: gameTime * 60), button: player2Button, extraTimeLabel: player2ExtraTimeLabel)
        player1Manager = PlayerUiManager(timeLabel: player1Label, player: Player(timeLeftInSecondsDouble: gameTime * 60), button: player1Button, extraTimeLabel: player1ExtraTimeLabel)
        
        setupForNewGame()
        setupUIForNewGame()
        
        customizeButtons([menuButton])
        
    }
    
    func setupForNewGame(){
    
        player1Manager?.player.timeLeftInSecondsDouble = gameTime * 60
        player2Manager?.player.timeLeftInSecondsDouble = gameTime * 60
        
    }

    
    func setupUIForNewGame(){
        
        player1Manager?.updateUiForNewGame()
        player2Manager?.updateUiForNewGame()
        
        stopButton.isEnabled = false
        stopButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        pausButton.isEnabled = false
        menuButton.isEnabled = true
        
        menuButton.setTitle("\(Int(gameTime)):\(bonusSecondsPerMove)", for: .normal)
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
        time = Date().timeIntervalSince1970
        player1Button.isEnabled = isPlayer1Active
        player2Button.isEnabled = !isPlayer1Active
        
        player1Manager?.timeLabel.textColor = isPlayer1Active ? .black : .darkGray
        player2Manager?.timeLabel.textColor = !isPlayer1Active ? .black : .darkGray
    }
    
    func startClock(){
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block:updatePlayerTime(timer:))
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
    

    func updatePlayerTime(timer: Timer? = nil){
        let newtime = Date().timeIntervalSince1970
        let elaspedTime = newtime - time
       
        
        if isPlayer1Active {
            if let player1Manager = player1Manager{
                if !player1Manager.timePassed(elapsedTime: elaspedTime){
                    gameOver(playerUiManager: player1Manager)
                }
            }
        }else{
            if let player2Manager = player2Manager {
                if !player2Manager.timePassed(elapsedTime: elaspedTime){
                    gameOver(playerUiManager: player2Manager)
                }
            }
        }
        time = newtime
    }
    
    
    func gameOver(playerUiManager: PlayerUiManager){
        playerUiManager.button.backgroundColor = .red
        stopClock()
        
        
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
    
    @IBAction func stopButtonPress(_ sender: Any) {
        guard let player1TimeLeft = player1Manager?.player.timeLeftInSecondsDouble else {return}
        guard let player2TimeLeft = player2Manager?.player.timeLeftInSecondsDouble else {return}
        
        if player1TimeLeft >= 0 && player2TimeLeft >= 0 {
            
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
}

