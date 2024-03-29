//
//  MenuViewController.swift
//  Clock
//
//  Created by Kristian Thun on 2024-03-13.
//

import UIKit

class MenuViewController: UIViewController {
    
    var gameTime : Double?
    var extraTime : Int?

    @IBOutlet weak var gameTimeInput: UITextField!
    
    @IBOutlet weak var extraTimeInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .popover
        if let gameTime = gameTime,
           let extraTime = extraTime{
            gameTimeInput.text = String(Int(gameTime))
            extraTimeInput.text = String(extraTime)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        makeSegue()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let gameTimeText = gameTimeInput.text{
            if let newGameTime = Int(gameTimeText){
                gameTime = Double(newGameTime)
            }
        }
        
        if let extraTimeText = extraTimeInput.text{
            if let newExtraTime = Int(extraTimeText){
                extraTime = newExtraTime
            }
        }

        makeSegue()
    }
    
    func makeSegue(){
        performSegue(withIdentifier: "unwindToParentViewController", sender: self)
    }
    
}
