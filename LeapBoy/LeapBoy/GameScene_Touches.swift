//
//  GameScene_Touches.swift
//  LeapBoy
//
//  Created by Dimka Novikov on 15.11.17.
//  Copyright © 2016 DDEC. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        heroEmitter2.isHidden = false
        
        if gameover == 0 {
            if tabToPlayLabel.isHidden == false {
                tabToPlayLabel.isHidden = true
            }
            
            if gameover == 0 {
                hero.physicsBody?.velocity = CGVector.zero
                hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
                
                heroFlyTexturesArray = [SKTexture(imageNamed: "Fly0.png"), SKTexture(imageNamed: "Fly1.png"), SKTexture(imageNamed: "Fly2.png"), SKTexture(imageNamed: "Fly3.png"), SKTexture(imageNamed: "Fly4.png")]
                let heroFlyAnimation = SKAction.animate(with: heroFlyTexturesArray, timePerFrame: 0.1)
                let flyHero = SKAction.repeatForever(heroFlyAnimation)
                hero.run(flyHero)
            }
        }
    }
}
