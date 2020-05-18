//
//  DifficultyViewController.swift
//  LeapBoy
//
//  Created by Dimka Novikov on 15.11.17.
//  Copyright © 2016 DDEC. All rights reserved.
//

import UIKit
import SpriteKit

class DifficultyViewController: UIViewController {
    
    @IBAction func selectDifficulty(sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect(filename: "button_press.wav")
        
        if let storyboard = storyboard {
            let selectBgViewController = storyboard.instantiateViewController(withIdentifier: "SelectBgViewController") as! SelectBgViewController
            
            selectBgViewController.selectBgDifficulty = DifficultyChoosing(rawValue: sender.tag)!
            
            navigationController?.pushViewController(selectBgViewController, animated: true)
            
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        navigationController?.popViewController(animated: true)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
