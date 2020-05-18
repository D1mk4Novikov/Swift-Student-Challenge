/*
*
*    Xcode Playground Project
*
*   - - - - - - - - - -
*
*    This project was created by me on the SpriteKit framework
*    at the end of 2017 as an Xcode project for the iPhone,
*    when I studied the SpriteKit, SceneKit, and Metal frameworks.
*    It was planned to further refine this game and its subsequent publication in the App Store.
*    Circumstances were not for the better and
*    now this game is presented as my project for Swift Student Challenge.
*
*   - - - - - - - - - -
*
*    Leap-Boy.playground
*    SpriteKit Game "Leap-Boy"
*
*    Created by Dimka Novikov on 07.05.2020
*    Copyright © 2020 //DDEC. All Rights Not Reserved.       :)
*
*    Country: Russia
*    Hometown: Yuzhno-Sakhalinsk       😎
*    The city in which the University is located: Krasnodar       🤓
*    University:
*            let university = (key: "KubSU", name: "Kuban State University", description: "🤡")
*
*   - - - - - - - - - -
*
*    Hardware & Software, which were used for testing:
*
*    - MacBook Air 13" Mid 2017
*
*    macOS Catalina (10.15.5 Developer Preview)
*
*    CPU: Dual-Core Intel Core i7
*    RAM: 8 GB LPDDR3
*    GPU: Intel HD Graphics 6000
*
*   - - - - -
*
*    - MacBook Pro 13" Mid 2019
*
*    macOS Catalina (10.15.4)
*
*    CPU: Quad-Core Intel Core i7
*    RAM: 16 GB LPDDR3
*    GPU: Intel Iris Plus Graphics 645
*
*/


// MARK: - Importing frameworks

// Importing a framework UIKit for working with UI elements
import UIKit

// Importing a framework SpriteKit for working with 2D graphics
import SpriteKit

// Importing a framework AVFoundation for working with music & sounds
import AVFoundation

// Importing a framework PlaygroundSupport to display graphics in real time
import PlaygroundSupport





// MARK: - Classes declaration

// Creating a GameSettings class
final class GameSettings {
    
    // Create a singleton instance
    static let sharedInstance = GameSettings()
    
    // Declaration enum storing difficulty level
    public enum Difficulty: Int {
        case easy = 0
        case medium = 1
        case hard = 2
    }
    
    // Declaration enum storing game scenes
    public enum GameScene: Int {
        case light = 0
        case dark = 1
    }
    
    // Create property stored seleted difficulty level
    public var difficulty: Difficulty = .easy
    
    // Create property stored seleted game scene
    public var selectedScene: GameScene = .light
    
    // Create a property stored game highscore
    public var highscore: Int = 0
    
    // Create a property stored game score
    public var score: Int = 0
    
}




// Creating a SKAudio class for working with sound effects
final class SKTAudio {
    public var backgroundMusicPlayer: AVAudioPlayer?
    public var soundEffectPlayer: AVAudioPlayer?
    
    public class func sharedInstance() -> SKTAudio {
        return SKTAudioInstance
    }
    
    public func playBackgroundMusic(filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        if (url == nil) {
            print("Could not find file: \(filename)")
            return
        }
        
        var error: NSError? = nil
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!)
        } catch let error1 as NSError {
            error = error1
            backgroundMusicPlayer = nil
        }
        if let player = backgroundMusicPlayer {
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.play()
        } else {
            print("Could not create audio player: \(error!)")
        }
    }
    
    public func pauseBackgroundMusic() {
        if let player = backgroundMusicPlayer {
            if player.isPlaying {
                player.pause()
            }
        }
    }
    
    public func resumeBackgroundMusic() {
        if let player = backgroundMusicPlayer {
            if !player.isPlaying {
                player.play()
            }
        }
    }
    
    public func playSoundEffect(filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        if (url == nil) {
            print("Could not find file: \(filename)")
            return
        }
        
        var error: NSError? = nil
        do {
            soundEffectPlayer = try AVAudioPlayer(contentsOf: url!)
        } catch let error1 as NSError {
            error = error1
            soundEffectPlayer = nil
        }
        if let player = soundEffectPlayer {
            player.numberOfLoops = 0
            player.prepareToPlay()
            player.play()
        } else {
            print("Could not create audio player: \(error!)")
        }
    }
}
private let SKTAudioInstance = SKTAudio()





// Creation an animation class
final class Animation {
    
    func scaleZdirection(sprite: SKSpriteNode) {
        sprite.run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.scale(by: 2.0, duration: 0.5),
                SKAction.scale(to: 1.0, duration: 1.0)
                ])
            ))
    }
    
    func redColorAnimation(sprite: SKSpriteNode, animDuration: TimeInterval) {
        sprite.run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.colorize(with: SKColor.red, colorBlendFactor: 1.0, duration: animDuration),
                SKAction.colorize(withColorBlendFactor: 0.0, duration: animDuration)
                ])
            ))
    }
    
    func rotateAnimationToAngle(sprite: SKSpriteNode, animDuration: TimeInterval) {
        sprite.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.rotate(toAngle: CGFloat.pi / 2, duration: animDuration),
            SKAction.rotate(toAngle: CGFloat.pi, duration: animDuration),
            SKAction.rotate(toAngle: -CGFloat.pi / 2, duration: animDuration),
            SKAction.rotate(toAngle: CGFloat.pi, duration: animDuration)
            ])))
    }
    
    func shakeAndFlashAnimation(view: SKView) {
        //White flash
        let aView = UIView(frame: view.frame)
        aView.backgroundColor = UIColor.white
        view.addSubview(aView)
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            aView.alpha = 0.0
            }) { (done) in
                aView.removeFromSuperview()
        }
        
        //Shake animation
        let shake = CAKeyframeAnimation(keyPath: "transform")
        shake.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(-15, 5, 5)),
            NSValue(caTransform3D: CATransform3DMakeTranslation(15, 5, 5))
        ]
        shake.autoreverses = true
        shake.repeatCount = 2
        shake.duration = 7/100
        
        view.layer.add(shake, forKey: nil)
    }
    
}





// Creating a GameScene class
//final class GameScene: SKScene, SKPhysicsContactDelegate {
//
//    //Animations
//    var animations = Animation()
//
//    //Variables
//    var gameViewControllerBridge: GameViewController!
//    var moveElectricGateY = SKAction()
//    var shieldBool = false
//    var gameover = 0
//    var rangeRocket :CGFloat = 0.50
//
//    //Texture
//    var bgTexture: SKTexture!
//    var flyHeroTex: SKTexture!
//    var runHeroTex: SKTexture!
//    var coinTexture: SKTexture!
//    var redCoinTexture: SKTexture!
//    var coinHeroTex: SKTexture!
//    var redCoinHeroTex: SKTexture!
//    var electricGateTex: SKTexture!
//    var deadHeroTex: SKTexture!
//    var shieldTexture: SKTexture!
//    var shieldItemTexture: SKTexture!
//    var mineTexture1: SKTexture!
//    var mineTexture2: SKTexture!
//    var rocketTex : SKTexture!
//    var rocketExplodeTex : SKTexture!
//
//    //Emitters Node
//    var heroEmitter2 = SKEmitterNode()
//
//    //Label Nodes
//    var tabToPlayLabel = SKLabelNode()
//    var scoreLabel = SKLabelNode()
//    var highscoreLabel = SKLabelNode()
//    var highscoreTextLabel = SKLabelNode()
//    var stageLabel = SKLabelNode()
//
//    //Sprite Nodes
//    var bg = SKSpriteNode()
//    var ground = SKSpriteNode()
//    var sky = SKSpriteNode()
//    var hero = SKSpriteNode()
//    var coin = SKSpriteNode()
//    var redCoin = SKSpriteNode()
//    var electricGate = SKSpriteNode()
//    var shield = SKSpriteNode()
//    var shieldItem = SKSpriteNode()
//    var mine = SKSpriteNode()
//    var rocket = SKSpriteNode()
//
//
//    //Sprite Objects
//    var bgObject = SKNode()
//    var groundObject = SKNode()
//    var movingObject = SKNode()
//    var heroObject = SKNode()
//    var heroEmitterObject = SKNode()
//    var coinObject = SKNode()
//    var redCoinObject = SKNode()
//    var shieldObject = SKNode()
//    var shieldItemObject = SKNode()
//    var labelObject = SKNode()
//    var rocketObject = SKNode()
//
//    //Bit masks
//    var heroGroup: UInt32 = 0x1 << 1
//    var groundGroup: UInt32 = 0x1 << 2
//    var coinGroup: UInt32 = 0x1 << 3
//    var redCoinGroup: UInt32 = 0x1 << 4
//    var objectGroup: UInt32 = 0x1 << 5
//    var shieldGroup: UInt32 = 0x1 << 6
//    var rocketGroup : UInt32 = 0x1 << 7
//
//    //Textures Array for animateWithTextures
//    var heroFlyTexturesArray = [SKTexture]()
//    var heroRunTexturesArray = [SKTexture]()
//    var coinTexturesArray = [SKTexture]()
//    var electricGateTexturesArray = [SKTexture]()
//    var heroDeathTexturesArray = [SKTexture]()
//    var rocketTexturesArray = [SKTexture]()
//    var rocketExplodeTexturesArray = [SKTexture]()
//
//    //Timers
//    var timerAddCoin = Timer()
//    var timerAddRedCoin = Timer()
//    var timerAddElectricGate = Timer()
//    var timerAddShieldItem = Timer()
//    var timerAddMine = Timer()
//    var timerAddRocket = Timer()
//
//    //Sounds
//    var pickCoinPreload = SKAction()
//    var electricGateCreatePreload = SKAction()
//    var electricGateDeadPreload = SKAction()
//    var shieldOnPreload = SKAction()
//    var shieldOffPreload = SKAction()
//    var rocketCreatePreload = SKAction()
//    var rocketExplosionPreload = SKAction()
//
//    override func didMove(to view: SKView) {
//        //Background texture
//        bgTexture = SKTexture(imageNamed: "Background_#2.png")
//
//        //Hero texture
//        flyHeroTex = SKTexture(imageNamed: "Fly0.png")
//        runHeroTex = SKTexture(imageNamed: "Run0.png")
//
//        //Coin texture
//        coinTexture = SKTexture(imageNamed: "coin.jpg")
//        redCoinTexture = SKTexture(imageNamed: "coin.jpg")
//        coinHeroTex = SKTexture(imageNamed: "Coin0.png")
//        redCoinHeroTex = SKTexture(imageNamed: "Coin0.png")
//
//        //ElectricGate texture
//        electricGateTex = SKTexture(imageNamed: "ElectricGate01.png")
//
//        //Shields and shield item texture
//        shieldTexture = SKTexture(imageNamed: "shield.png")
//        shieldItemTexture = SKTexture(imageNamed: "shieldItem.png")
//
//        //Mines texture
//        mineTexture1 = SKTexture(imageNamed: "mine1.png")
//        mineTexture2 = SKTexture(imageNamed: "mine2.png")
//
//        // Rocket Textures
//        rocketTex = SKTexture(imageNamed: "Rocket0.png")
//        rocketExplodeTex = SKTexture(imageNamed: "RocketExplode0.png")
//
//        //Emitters
//        heroEmitter2 = SKEmitterNode(fileNamed: "EngineThrottle.sks")!
//
//        self.physicsWorld.contactDelegate = self
//
//        createObjects()
//
//        highscoreLabel.text = String(GameSettings.sharedInstance.highscore)
////        if UserDefaults.standard.object(forKey: "highScore") != nil {
////            Model.sharedInstance.highscore = UserDefaults.standard.object(forKey: "highScore") as! Int
////            highscoreLabel.text = "\(Model.sharedInstance.highscore)"
////        }
//
////        if UserDefaults.standard.object(forKey: "totalscore") != nil {
////            Model.sharedInstance.totalscore = UserDefaults.standard.object(forKey: "totalscore") as! Int
////        }
//
//        if gameover == 0 {
//            createGame()
//        }
//
//        pickCoinPreload = SKAction.playSoundFileNamed("PickUpCoin.mp3", waitForCompletion: false)
//        electricGateCreatePreload = SKAction.playSoundFileNamed("ElectricCreate.wav", waitForCompletion: false)
//        electricGateDeadPreload = SKAction.playSoundFileNamed("ElectricDead.mp3", waitForCompletion: false)
//        shieldOnPreload = SKAction.playSoundFileNamed("ShieldOn.mp3", waitForCompletion: false)
//        shieldOffPreload = SKAction.playSoundFileNamed("ShieldOff.mp3", waitForCompletion: false)
//        rocketExplosionPreload = SKAction.playSoundFileNamed("RocketExplosion.wav", waitForCompletion: false)
//        rocketCreatePreload = SKAction.playSoundFileNamed("RocketCreate.wav", waitForCompletion: false)
//    }
//
//    func createObjects() {
//        self.addChild(bgObject)
//        self.addChild(groundObject)
//        self.addChild(movingObject)
//        self.addChild(heroObject)
//        self.addChild(heroEmitterObject)
//        self.addChild(coinObject)
//        self.addChild(redCoinObject)
//        self.addChild(shieldObject)
//        self.addChild(shieldItemObject)
//        self.addChild(labelObject)
//        self.addChild(rocketObject)
//    }
//
//    func createGame() {
//        createBg()
//        createGround()
//        createSky()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
//            self.createHero()
//            self.createHeroEmitter()
//            self.timerFunc()
//            self.addElectricGate()
//        }
//
//        showTapToPlay()
//        showScore()
//        showStage()
//        highscoreTextLabel.isHidden = true
//
//        gameViewControllerBridge.restartGameButton.isHidden = true
//        gameViewControllerBridge.backButton.isHidden = true
//
//        if labelObject.children.count != 0 {
//            labelObject.removeAllChildren()
//        }
//    }
//
//    func createBg() {
//        var correctHeight: CGFloat = 0
//        switch GameSettings.sharedInstance.selectedScene.rawValue {
//        case 0:
//            bgTexture = SKTexture(imageNamed: "Background_#2.png")
//            correctHeight = 2.0
//        case 1:
//            bgTexture = SKTexture(imageNamed: "Background_#3.png")
//            correctHeight = 1.8
//        default:
//            break
//        }
//
//        let moveBg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 3)
//        let replaceBg = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
//        let moveBgForever = SKAction.repeatForever(SKAction.sequence([moveBg, replaceBg]))
//
//        for i in 0..<3 {
//            bg = SKSpriteNode(texture: bgTexture)
//            bg.position = CGPoint(x: size.width/4 + bgTexture.size().width * CGFloat(i), y: size.height/correctHeight)
//            bg.size.height = self.frame.height
//            bg.run(moveBgForever)
//            bg.zPosition = -1
//
//            bgObject.addChild(bg)
//        }
//    }
//
//    func createGround() {
//        ground = SKSpriteNode()
//        ground.position = CGPoint.zero
//        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: self.frame.height/4 + self.frame.height/8))
//        ground.physicsBody?.isDynamic = false
//        ground.physicsBody?.categoryBitMask = groundGroup
//        ground.zPosition = 1
//
//        groundObject.addChild(ground)
//    }
//
//    func createSky() {
//        sky = SKSpriteNode()
//        sky.position = CGPoint(x: 0, y: self.frame.maxX)
//        sky.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width + 100, height: self.frame.size.height - 100))
//        sky.physicsBody?.isDynamic = false
//        sky.zPosition = 1
//
//        movingObject.addChild(sky)
//    }
//
//    func addHero(heroNode: SKSpriteNode, atPosition position: CGPoint) {
//        hero = SKSpriteNode(texture: flyHeroTex)
//
//        //Anim hero
//        heroFlyTexturesArray = [SKTexture(imageNamed: "Fly0.png"), SKTexture(imageNamed: "Fly1.png"), SKTexture(imageNamed: "Fly2.png"), SKTexture(imageNamed: "Fly3.png"), SKTexture(imageNamed: "Fly4.png")]
//        let heroFlyAnimation = SKAction.animate(with: heroFlyTexturesArray, timePerFrame: 0.1)
//        let flyHero = SKAction.repeatForever(heroFlyAnimation)
//        hero.run(flyHero)
//
//        hero.position = position
//        hero.size.height = 84
//        hero.size.width = 120
//
//        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: hero.size.width - 40, height: hero.size.height - 30))
//
//        hero.physicsBody?.categoryBitMask = heroGroup
//        hero.physicsBody?.contactTestBitMask = groundGroup | coinGroup | redCoinGroup | objectGroup | shieldGroup | rocketGroup
//        hero.physicsBody?.collisionBitMask = groundGroup
//
//        hero.physicsBody?.isDynamic = true
//        hero.physicsBody?.allowsRotation = false
//        hero.zPosition = 1
//
//        heroObject.addChild(hero)
//    }
//
//    func createHero() {
//        addHero(heroNode: hero, atPosition: CGPoint(x: self.size.width/4, y: 0 + flyHeroTex.size().height + 400))
//    }
//
//    func createHeroEmitter() {
//        heroEmitter2 = SKEmitterNode(fileNamed: "EngineThrottle.sks")!
//        heroEmitterObject.zPosition = 1
//        heroEmitterObject.addChild(heroEmitter2)
//    }
//
//    @objc func addCoin() {
//        coin = SKSpriteNode(texture: coinTexture)
//
//        coinTexturesArray = [SKTexture(imageNamed: "Coin0.png"), SKTexture(imageNamed: "Coin1.png"), SKTexture(imageNamed: "Coin2.png"), SKTexture(imageNamed: "Coin3.png")]
//
//        let coinAnimation = SKAction.animate(with: coinTexturesArray, timePerFrame: 0.1)
//        let coinHero = SKAction.repeatForever(coinAnimation)
//        coin.run(coinHero)
//
//        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
//        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
//        coin.size.width = 40
//        coin.size.height = 40
//        coin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: coin.size.width - 20, height: coin.size.height - 20))
//        coin.physicsBody?.restitution = 0
//        coin.position = CGPoint(x: self.size.width + 50, y: 0 + coinTexture.size().height + 90 + pipeOffset)
//
//        let moveCoin = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: 5)
//        let removeAction = SKAction.removeFromParent()
//        let coinMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveCoin, removeAction]))
//        coin.run(coinMoveBgForever)
//
//        coin.physicsBody?.isDynamic = false
//        coin.physicsBody?.categoryBitMask = coinGroup
//        coin.zPosition = 1
//        coinObject.addChild(coin)
//    }
//
//    @objc func redCoinAdd() {
//        redCoin = SKSpriteNode(texture: redCoinTexture)
//
//        coinTexturesArray = [SKTexture(imageNamed: "Coin0.png"), SKTexture(imageNamed: "Coin1.png"), SKTexture(imageNamed: "Coin2.png"), SKTexture(imageNamed: "Coin3.png")]
//
//        let redCoinAnimation = SKAction.animate(with: coinTexturesArray, timePerFrame: 0.1)
//        let redCoinHero = SKAction.repeatForever(redCoinAnimation)
//        redCoin.run(redCoinHero)
//
//        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
//        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
//        redCoin.size.width = 40
//        redCoin.size.height = 40
//        redCoin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: redCoin.size.width - 10, height: redCoin.size.height - 10))
//        redCoin.physicsBody?.restitution = 0
//        redCoin.position = CGPoint(x: self.size.width + 50, y: 0 + coinTexture.size().height + 90 + pipeOffset)
//
//        let moveCoin = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: 5)
//        let removeAction = SKAction.removeFromParent()
//        let coinMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveCoin, removeAction]))
//        redCoin.run(coinMoveBgForever)
//        animations.scaleZdirection(sprite: redCoin)
//        animations.redColorAnimation(sprite: redCoin, animDuration: 0.5)
//        redCoin.setScale(1.3)
//        redCoin.physicsBody?.isDynamic = false
//        redCoin.physicsBody?.categoryBitMask = redCoinGroup
//        redCoin.zPosition = 1
//        redCoinObject.addChild(redCoin)
//    }
//
//    @objc func addElectricGate() {
////        if Model.sharedInstance.sound == true {
//        run(electricGateCreatePreload)
////        }
//
//        electricGate = SKSpriteNode(texture: electricGateTex)
//
//        electricGateTexturesArray = [SKTexture(imageNamed: "ElectricGate01.png"), SKTexture(imageNamed: "ElectricGate02.png"), SKTexture(imageNamed: "ElectricGate03.png"), SKTexture(imageNamed: "ElectricGate04.png")]
//
//        let electricGateAnimation = SKAction.animate(with: electricGateTexturesArray, timePerFrame: 0.1)
//        let electricGateAnimationForever = SKAction.repeatForever(electricGateAnimation)
//        electricGate.run(electricGateAnimationForever)
//
//        let randomPosition = arc4random() % 2
//        let movementAmount = arc4random() % UInt32(self.frame.size.height / 5)
//        let pipeOffset = self.frame.size.height / 4 + 30 - CGFloat(movementAmount)
//
//        if randomPosition == 0 {
//            electricGate.position = CGPoint(x: self.size.width + 50, y: 0 + electricGateTex.size().height/2 + 90 + pipeOffset)
//            electricGate.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: electricGate.size.width - 40, height: electricGate.size.height - 20))
//        } else {
//            electricGate.position = CGPoint(x: self.size.width + 50, y: self.frame.size.height - electricGateTex.size().height/2 - 90 - pipeOffset)
//            electricGate.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: electricGate.size.width - 40, height: electricGate.size.height - 20))
//        }
//
//        //Rotate
//        electricGate.run(SKAction.repeatForever(SKAction.sequence([SKAction.run({
//            self.electricGate.run(SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 0.5))
//        }), SKAction.wait(forDuration: 20.0)])))
//
//        //Move
//        let moveAction = SKAction.moveBy(x: -self.frame.width - 300, y: 0, duration: 6)
//        electricGate.run(moveAction)
//
//        //Scale
//        var scaleValue: CGFloat = 0.3
//
//
//        let scaleRandom = arc4random() % UInt32(5)
//        if scaleRandom == 1 { scaleValue = 0.9 }
//        else if scaleRandom == 2 { scaleValue = 0.6 }
//        else if scaleRandom == 3 { scaleValue = 0.8 }
//        else if scaleRandom == 4 { scaleValue = 0.7 }
//        else if scaleRandom == 0 { scaleValue = 1.0 }
//
//        electricGate.setScale(scaleValue)
//
//        let movementRandom = arc4random() % 9
//        if movementRandom == 0 {
//            moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 + 220, duration: 4)
//        } else if movementRandom == 1 {
//            moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 - 220, duration: 5)
//        } else if movementRandom == 2 {
//            moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 - 150, duration: 4)
//        } else if movementRandom == 3 {
//            moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 + 150, duration: 5)
//        } else if movementRandom == 4 {
//            moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 + 50, duration: 4)
//        } else if movementRandom == 5 {
//            moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2 - 50, duration: 5)
//        } else {
//            moveElectricGateY = SKAction.moveTo(y: self.frame.height / 2, duration: 4)
//        }
//
//        electricGate.run(moveElectricGateY)
//
//        electricGate.physicsBody?.restitution = 0
//        electricGate.physicsBody?.isDynamic = false
//        electricGate.physicsBody?.categoryBitMask = objectGroup
//        electricGate.zPosition = 1
//        movingObject.addChild(electricGate)
//    }
//
//    @objc func addMine() {
//        mine = SKSpriteNode(texture: mineTexture1)
//        let minesRandom = arc4random() % UInt32(2)
//        if minesRandom == 0 {
//            mine = SKSpriteNode(texture: mineTexture1)
//        } else {
//            mine = SKSpriteNode(texture: mineTexture2)
//        }
//
//        mine.size.width = 70
//        mine.size.height = 62
//        mine.position = CGPoint(x: self.frame.size.width + 150, y: self.frame.size.height / 4 - self.frame.size.height / 24)
//
//        let moveMineX = SKAction.moveTo(x: -self.frame.size.width / 4, duration: 4)
//        mine.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: mine.size.width - 40, height: mine.size.height - 30))
//        mine.physicsBody?.categoryBitMask = objectGroup
//        mine.physicsBody?.isDynamic = false
//
//        let removeAction = SKAction.removeFromParent()
//        let mineMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveMineX, removeAction]))
//
//        animations.rotateAnimationToAngle(sprite: mine, animDuration: 0.2)
//
//        mine.run(mineMoveBgForever)
//        mine.zPosition = 1
//        movingObject.addChild(mine)
//    }
//
//    func addShield() {
//        shield = SKSpriteNode(texture: shieldTexture)
////        if Model.sharedInstance.sound == true { run(shieldOnPreload) }
//        run(shieldOnPreload)
//        shield.zPosition = 1
//        shieldObject.addChild(shield)
//    }
//
//    @objc func addShieldItem() {
//        shieldItem = SKSpriteNode(texture: shieldItemTexture)
//
//        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
//        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
//
//        shieldItem.position = CGPoint(x: self.size.width + 50, y: 0 + shieldItemTexture.size().height + self.size.height / 2 + pipeOffset)
//        shieldItem.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shieldItem.size.width - 20, height: shieldItem.size.height - 20))
//        shieldItem.physicsBody?.restitution = 0
//
//        let moveShield = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: 5)
//        let removeAction = SKAction.removeFromParent()
//        let shieldItemMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveShield, removeAction]))
//        shieldItem.run(shieldItemMoveBgForever)
//
//        animations.scaleZdirection(sprite: shieldItem)
//        shieldItem.setScale(1.1)
//
//        shieldItem.physicsBody?.isDynamic = false
//        shieldItem.physicsBody?.categoryBitMask = shieldGroup
//        shieldItem.zPosition = 1
//        shieldItemObject.addChild(shieldItem)
//
//    }
//
//    @objc func addRocket() {
//
//        rocket = SKSpriteNode(texture: rocketTex)
//        rocket.size.width = 180
//        rocket.size.height = 55
//
////        if Model.sharedInstance.sound == true { run(rocketCreatePreload) }
//        run(rocketCreatePreload)
//
//        let movementRandom = arc4random() % 8
//        if movementRandom == 0 {
//            rocket.position = CGPoint(x: self.frame.width + 100, y: self.frame.height / 2 + 220)
//        } else if movementRandom == 1 {
//            rocket.position = CGPoint(x: self.frame.width + 100, y: self.frame.height / 2 - 220)
//        } else if movementRandom == 2 {
//            rocket.position = CGPoint(x: self.frame.width + 100, y: self.frame.height / 2 + 120)
//        } else if movementRandom == 3 {
//            rocket.position = CGPoint(x: self.frame.width + 100, y: self.frame.height / 2 - 120)
//        } else if movementRandom == 4 {
//            rocket.position = CGPoint(x: self.frame.width + 100, y: self.frame.height / 2 + 50)
//        } else if movementRandom == 5 {
//            rocket.position = CGPoint(x: self.frame.width + 100, y: self.frame.height / 2 - 50)
//        } else {
//            rocket.position = CGPoint(x: self.frame.width + 100, y: self.frame.height / 2)
//        }
//
//        let moveFuze = SKAction.moveTo(x: -self.frame.size.width / 4 , duration: 4)
//
//        rocketTexturesArray = [SKTexture(imageNamed: "Rocket0"), SKTexture(imageNamed: "Rocket1"), SKTexture(imageNamed: "Rocket2"), SKTexture(imageNamed: "Rocket3"), SKTexture(imageNamed: "Rocket4"), SKTexture(imageNamed: "Rocket5")]
//
//        let rocketAnimation = SKAction.animate(with: rocketTexturesArray, timePerFrame: 0.1)
//
//        let flyFuze = SKAction.repeatForever(rocketAnimation)
//
//        rocket.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rocket.size.width - 20 , height: rocket.size.height - 10))
//
//        rocket.physicsBody?.categoryBitMask = rocketGroup
//
//        rocket.physicsBody?.isDynamic = false
//
//        let maxAspectRatio:CGFloat = 16.0/9.0 // iPhone 5"
//        let maxAspectRatioHeight = size.width / maxAspectRatio
//        let playableMargin = (size.height-maxAspectRatioHeight)/2.0
//        let playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height-playableMargin*2)
//        let removeAction = SKAction.removeFromParent()
//        let rocketMoveBgForever = SKAction.repeatForever(SKAction.sequence([moveFuze,removeAction]))
//
//        switch stageLabel.text! {
//        case "Stage 1":
//            rangeRocket = 0.10
//        case "Stage 2":
//            rangeRocket = 0.13
//        case "Stage 3":
//            rangeRocket = 0.15
//        default:break
//        }
//
//        rocket.run(SKAction.repeat(
//            SKAction.sequence([
//                SKAction.moveBy(x: 0, y: playableRect.height * rangeRocket, duration: 1.0),
//                SKAction.moveBy(x: 0, y: -playableRect.height * rangeRocket, duration: 1.0)
//                ]), count:4
//            ))
//
//        rocket.run(rocketMoveBgForever)
//        rocket.run(flyFuze)
//
//        rocket.zPosition = 1
//
//        rocketObject.addChild(rocket)
//    }
//
//    func showTapToPlay() {
//        tabToPlayLabel.text = "Tap to Fly!!!"
//        tabToPlayLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
//        tabToPlayLabel.fontSize = 50
//        tabToPlayLabel.fontColor = UIColor.white
//        tabToPlayLabel.fontName = "Chalkduster"
//        tabToPlayLabel.zPosition = 1
//        self.addChild(tabToPlayLabel)
//    }
//
//    func showScore() {
//        scoreLabel.fontName = "Chalkduster"
//        scoreLabel.text = "0"
//        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 200)
//        scoreLabel.fontSize = 60
//        scoreLabel.fontColor = UIColor.white
//        scoreLabel.zPosition = 1
//        self.addChild(scoreLabel)
//    }
//
//    func showHighscore() {
//        highscoreLabel = SKLabelNode()
//        highscoreLabel.position = CGPoint(x: self.frame.maxX - 100, y: self.frame.maxY - 210)
//        highscoreLabel.fontSize = 50
//        highscoreLabel.fontName = "Chalkduster"
//        highscoreLabel.fontColor = UIColor.white
//        highscoreLabel.isHidden = true
//        highscoreLabel.zPosition = 1
//        labelObject.addChild(highscoreLabel)
//    }
//
//    func showHighscoreText() {
//        highscoreTextLabel = SKLabelNode()
//        highscoreTextLabel.position = CGPoint(x: self.frame.maxX - 100, y: self.frame.maxY - 150)
//        highscoreTextLabel.fontSize = 30
//        highscoreTextLabel.fontName = "Chalkduster"
//        highscoreTextLabel.fontColor = UIColor.white
//        highscoreTextLabel.text = "HighScore"
//        highscoreTextLabel.zPosition = 1
//        labelObject.addChild(highscoreTextLabel)
//    }
//
//    func showStage() {
//        stageLabel.position = CGPoint(x: self.frame.maxX - 60, y: self.frame.maxY - 140)
//        stageLabel.fontSize = 30
//        stageLabel.fontName = "Chalkduster"
//        stageLabel.fontColor = UIColor.white
//        stageLabel.text = "Stage 1"
//        stageLabel.zPosition = 1
//        self.addChild(stageLabel)
//    }
//
//    func levelUp() {
//        if 1 <= GameSettings.sharedInstance.score && GameSettings.sharedInstance.score < 20 {
//            stageLabel.text = "Stage 1"
//            coinObject.speed = 1.05
//            redCoinObject.speed = 1.1
//            movingObject.speed = 1.05
//            rocketObject.speed = 1.05
//            self.speed = 1.05
//        } else if 20 <= GameSettings.sharedInstance.score && GameSettings.sharedInstance.score < 36 {
//            stageLabel.text = "Stage 2"
//            coinObject.speed = 1.22
//            redCoinObject.speed = 1.32
//            movingObject.speed = -1.22
//            rocketObject.speed = 1.22
//            self.speed = 1.22
//        } else if 36 <= GameSettings.sharedInstance.score && GameSettings.sharedInstance.score < 56 {
//            stageLabel.text = "Stage 3"
//            coinObject.speed = 1.3
//            redCoinObject.speed = 1.35
//            movingObject.speed = 1.3
//            rocketObject.speed = 1.3
//            self.speed = 1.3
//        }
//    }
//
//    func timerFunc() {
//        timerAddCoin.invalidate()
//        timerAddRedCoin.invalidate()
//        timerAddElectricGate.invalidate()
//        timerAddMine.invalidate()
//        timerAddShieldItem.invalidate()
//        timerAddRocket.invalidate()
//
//        timerAddCoin = Timer.scheduledTimer(timeInterval: 2.64, target: self, selector: #selector(GameScene.addCoin), userInfo: nil, repeats: true)
//        timerAddRedCoin = Timer.scheduledTimer(timeInterval: 8.246, target: self, selector: #selector(GameScene.redCoinAdd), userInfo: nil, repeats: true)
//
//        switch GameSettings.sharedInstance.difficulty.rawValue {
//        case 0: //easy mode
//            timerAddElectricGate = Timer.scheduledTimer(timeInterval: 5.234, target: self, selector: #selector(GameScene.addElectricGate), userInfo: nil, repeats: true)
//            timerAddMine = Timer.scheduledTimer(timeInterval: 4.245, target: self, selector: #selector(GameScene.addMine), userInfo: nil, repeats: true)
//            timerAddRocket = Timer.scheduledTimer(timeInterval: 3.743, target: self, selector: #selector(GameScene.addRocket), userInfo: nil, repeats: true)
//
//            timerAddShieldItem = Timer.scheduledTimer(timeInterval: 20.246, target: self, selector: #selector(GameScene.addShieldItem), userInfo: nil, repeats: true)
//        case 1: //medium mode
//            timerAddElectricGate = Timer.scheduledTimer(timeInterval: 3.234, target: self, selector: #selector(GameScene.addElectricGate), userInfo: nil, repeats: true)
//            timerAddMine = Timer.scheduledTimer(timeInterval: 3.245, target: self, selector: #selector(GameScene.addMine), userInfo: nil, repeats: true)
//            timerAddRocket = Timer.scheduledTimer(timeInterval: 2.743, target: self, selector: #selector(GameScene.addRocket), userInfo: nil, repeats: true)
//
//            timerAddShieldItem = Timer.scheduledTimer(timeInterval: 30.246, target: self, selector: #selector(GameScene.addShieldItem), userInfo: nil, repeats: true)
//        case 2: //hard mode
//            timerAddElectricGate = Timer.scheduledTimer(timeInterval: 3.034, target: self, selector: #selector(GameScene.addElectricGate), userInfo: nil, repeats: true)
//            timerAddMine = Timer.scheduledTimer(timeInterval: 2.945, target: self, selector: #selector(GameScene.addMine), userInfo: nil, repeats: true)
//            timerAddRocket = Timer.scheduledTimer(timeInterval: 2.543, target: self, selector: #selector(GameScene.addRocket), userInfo: nil, repeats: true)
//
//            timerAddShieldItem = Timer.scheduledTimer(timeInterval: 40.246, target: self, selector: #selector(GameScene.addShieldItem), userInfo: nil, repeats: true)
//        default: break
//        }
//    }
//
//    func stopGameObject() {
//        coinObject.speed = 0
//        redCoinObject.speed = 0
//        movingObject.speed = 0
//        heroObject.speed = 0
//        rocketObject.speed = 0
//    }
//
//    func reloadGame() {
//
////        if Model.sharedInstance.sound == true {
////            SKTAudio.sharedInstance().resumeBackgroundMusic()
////        }
//        SKTAudio.sharedInstance().resumeBackgroundMusic()
//
//        coinObject.removeAllChildren()
//        redCoinObject.removeAllChildren()
//
//        stageLabel.text = "Stage 1"
//        gameover = 0
//        scene?.isPaused = false
//
//        movingObject.removeAllChildren()
//        rocketObject.removeAllChildren()
//        heroObject.removeAllChildren()
//
//        coinObject.speed = 1
//        heroObject.speed = 1
//        movingObject.speed = 1
//        rocketObject.speed = 1
//        self.speed = 1
//
//        if labelObject.children.count != 0 {
//            labelObject.removeAllChildren()
//        }
//
//        createGround()
//        createSky()
//        createHero()
//        createHeroEmitter()
//
//        gameViewControllerBridge.backButton.isHidden = true
//
//        GameSettings.sharedInstance.score = 0
//        scoreLabel.text = "0"
//        stageLabel.isHidden = false
//        highscoreTextLabel.isHidden = true
//        showHighscore()
//
//        timerAddCoin.invalidate()
//        timerAddRedCoin.invalidate()
//        timerAddElectricGate.invalidate()
//        timerAddMine.invalidate()
//        timerAddShieldItem.invalidate()
//        timerAddRocket.invalidate()
//
//        timerFunc()
//    }
//
//    override func didFinishUpdate() {
////        heroEmitter2.position = hero.position - CGPoint(x: 30, y: 5)
////        shield.position = hero.position + CGPoint(x: 0, y: 0)
//    }
//
//    func removeAll() {
//        GameSettings.sharedInstance.score = 0
//        scoreLabel.text = "0"
//
//        gameover = 0
//
//        if labelObject.children.count != 0 {
//            labelObject.removeAllChildren()
//        }
//
//        timerAddCoin.invalidate()
//        timerAddRedCoin.invalidate()
//        timerAddElectricGate.invalidate()
//        timerAddMine.invalidate()
//        timerAddShieldItem.invalidate()
//        timerAddRocket.invalidate()
//
//        self.removeAllActions()
//        self.removeAllChildren()
//        self.removeFromParent()
//        self.view?.removeFromSuperview()
//        gameViewControllerBridge = nil
//    }
//
//}





// Creating a GameViewController class
final class GameViewController: UIViewController {
    
    // Overriding property that determine the ability to rotate the screen
    override var shouldAutorotate: Bool {
        return false
    }
    
    // Overriding property that define possible orientations
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
//    let scene = GameScene(size: CGSize(width: 375, height: 668))
//    let textureAtlas = SKTextureAtlas(named: "Scene.Atlas")
    
    
    // Create button for restarting a game
    public let restartGameButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "RestartGameButton.png"), for: .normal)
        button.setImage(UIImage(named: "RestartGameButton.png"), for: .highlighted)
        button.tag = 0
        button.isHidden = false
        button.addTarget(self, action: #selector(buttonTouchDown(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUpOutside(sender:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(buttonTouchUpInside(sender:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // Create a back button
    public let backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "SceneSelectionButton.png"), for: .normal)
        button.setImage(UIImage(named: "SceneSelectionButton.png"), for: .highlighted)
        button.tag = 1
        button.isHidden = false
        button.addTarget(self, action: #selector(buttonTouchDown(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUpOutside(sender:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(buttonTouchUpInside(sender:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemPink
        
        self.view.addSubview(self.restartGameButton)
        self.restartGameButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.restartGameButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50.0).isActive = true
        self.restartGameButton.widthAnchor.constraint(equalToConstant: 20.0)
        self.restartGameButton.heightAnchor.constraint(equalToConstant: 20.0)
        
        self.view.addSubview(self.backButton)
        self.backButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.backButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 50.0).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 20.0)
        self.backButton.heightAnchor.constraint(equalToConstant: 20.0)
        
        
        
        print(GameSettings.sharedInstance.difficulty.rawValue)
        print(GameSettings.sharedInstance.selectedScene.rawValue)
        
        
    }
    
    
    // BackButton handler
    @objc private func buttonTouchDown(sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect(filename: "PressButton.wav")
        UIView.animate(withDuration: 0.15) {
            sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            sender.alpha = 0.3
        }
    }
    
    // BackButton release handler outside its borders
    @objc private func buttonTouchUpOutside(sender: UIButton) {
        UIView.animate(withDuration: 0.15) {
            sender.transform = .identity
            sender.alpha = 1.0
        }
    }
    
    // BackButton release handler inside its borders
    @objc private func buttonTouchUpInside(sender: UIButton) {
        if sender.tag == 0 {
//            scene.reloadGame()
//            scene.gameViewControllerBridge = self
        } else {
            self.dismiss(animated: true, completion: nil)
//            DispatchQueue.main.async {
//                self.scene.removeAll()
//            }
        }
        UIView.animate(withDuration: 0.15) {
            sender.transform = .identity
            sender.alpha = 1.0
        }
        self.restartGameButton.isHidden = true
        self.backButton.isHidden = true
    }

    
    
}





// Creating a GameSceneSelectionViewController class
final class GameSceneSelectionViewController: UIViewController {
    
    // Overriding property that determine the ability to rotate the screen
    override var shouldAutorotate: Bool {
        return false
    }
    
    // Overriding property that define possible orientations
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    // Creating a constant storing background
    private let backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "Background_#1.png")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImageView
    }()
    
    // Create a visual blur effect for the background
    private let backgroundBlurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: .regular)
        blurView.isUserInteractionEnabled = true
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    // Create a vibrancy visual effect for the background
    private let backgroundVibrancyView: UIVisualEffectView = {
        let vibrancyView = UIVisualEffectView()
        vibrancyView.effect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .regular), style: .fill)
        vibrancyView.isUserInteractionEnabled = true
        vibrancyView.clipsToBounds = true
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        return vibrancyView
    }()
    
    // Creating the first level of UIStackView
    private let firstStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isUserInteractionEnabled = true
        stackView.clipsToBounds = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Creating the second level of UIStackView
    private let secondStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isUserInteractionEnabled = true
        stackView.clipsToBounds = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Create GameScene structure
    private struct GameScene {
        var view: UIView
        var scene: UIImageView
        var button: UIButton
    }
    
    // Declaring an array of DifficultyLevel
    private var gameScenes = [GameScene]()
    
    // Creating a UIView for the back button
    private let backButtonView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 8.0
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Create a UILabel for back button
    private let backButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "Difficulty Setting"
        label.font = UIFont(name: "Helvetica Neue", size: 25.0)
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.isUserInteractionEnabled = true
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Create a back button
    private let backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTouchDown(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(backButtonTouchUpOutside(sender:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(backButtonTouchUpInside(sender:)), for: .touchUpInside)
        return button
    }()
    
    
    
    // Overriding "viewDidLoad" method
    override func viewDidLoad() {
        
        // Parent method call
        super.viewDidLoad()
        
        
        // Adding backgroundImageView as sub view to the main view
        self.view.addSubview(self.backgroundImageView)
        
        // Setting constraints for backgroundImageView
        self.backgroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.backgroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        // Adding backgroundBlurView as sub view to the backgroundImageView
        self.backgroundImageView.addSubview(self.backgroundBlurView)

        // Setting constraints for backgroundBlurView
        self.backgroundBlurView.leadingAnchor.constraint(equalTo: self.backgroundImageView.leadingAnchor).isActive = true
        self.backgroundBlurView.trailingAnchor.constraint(equalTo: self.backgroundImageView.trailingAnchor).isActive = true
        self.backgroundBlurView.topAnchor.constraint(equalTo: self.backgroundImageView.topAnchor).isActive = true
        self.backgroundBlurView.bottomAnchor.constraint(equalTo: self.backgroundImageView.bottomAnchor).isActive = true
        
        
        // Adding backgroundVibrancyView as content view to the backgroundBlurView
        self.backgroundBlurView.contentView.addSubview(self.backgroundVibrancyView)
        
        // Setting constraints for backgroundVibrancyView
        self.backgroundVibrancyView.leadingAnchor.constraint(equalTo: self.backgroundBlurView.leadingAnchor).isActive = true
        self.backgroundVibrancyView.trailingAnchor.constraint(equalTo: self.backgroundBlurView.trailingAnchor).isActive = true
        self.backgroundVibrancyView.topAnchor.constraint(equalTo: self.backgroundBlurView.topAnchor).isActive = true
        self.backgroundVibrancyView.bottomAnchor.constraint(equalTo: self.backgroundBlurView.bottomAnchor).isActive = true
        
        
        // Filling an array with elements
        for _ in 0 ... 1 {
            self.gameScenes.append(GameScene(view: UIView(), scene: UIImageView(), button: UIButton(type: .custom)))
        }


        // Setting the view field of the structure
        for i in 0 ..< self.gameScenes.count {
            self.gameScenes[i].view.isUserInteractionEnabled = true
            self.gameScenes[i].view.clipsToBounds = true
            self.gameScenes[i].view.translatesAutoresizingMaskIntoConstraints = false
        }


        // Setting the image field of the structure
        for i in 0 ..< self.gameScenes.count {
            self.gameScenes[i].view.addSubview(self.gameScenes[i].scene)
            self.gameScenes[i].scene.image = UIImage(named: "Background_#\(i + 2).png")
            self.gameScenes[i].scene.contentMode = .scaleAspectFill
            self.gameScenes[i].scene.layer.cornerRadius = 8.0
            self.gameScenes[i].scene.isUserInteractionEnabled = true
            self.gameScenes[i].scene.clipsToBounds = true
            self.gameScenes[i].scene.translatesAutoresizingMaskIntoConstraints = false
            self.gameScenes[i].scene.leadingAnchor.constraint(equalTo: self.gameScenes[i].view.leadingAnchor).isActive = true
            self.gameScenes[i].scene.trailingAnchor.constraint(equalTo: self.gameScenes[i].view.trailingAnchor).isActive = true
            self.gameScenes[i].scene.topAnchor.constraint(equalTo: self.gameScenes[i].view.topAnchor).isActive = true
            self.gameScenes[i].scene.bottomAnchor.constraint(equalTo: self.gameScenes[i].view.bottomAnchor).isActive = true
        }


        // Setting the button field of the structure
        for i in 0 ..< self.gameScenes.count {
            self.gameScenes[i].view.addSubview(self.gameScenes[i].button)
            self.gameScenes[i].button.tag = i
            self.gameScenes[i].button.isUserInteractionEnabled = true
            self.gameScenes[i].button.clipsToBounds = true
            self.gameScenes[i].button.translatesAutoresizingMaskIntoConstraints = false
            self.gameScenes[i].button.addTarget(self, action: #selector(sceneSelectionButtonTouchDown(sender:)), for: .touchDown)
            self.gameScenes[i].button.addTarget(self, action: #selector(sceneSelectionButtonTouchUpOutside(sender:)), for: .touchUpOutside)
            self.gameScenes[i].button.addTarget(self, action: #selector(sceneSelectionButtonTouchUpInside(sender:)), for: .touchUpInside)
            self.gameScenes[i].view.leadingAnchor.constraint(equalTo: self.gameScenes[i].button.leadingAnchor).isActive = true
            self.gameScenes[i].view.trailingAnchor.constraint(equalTo: self.gameScenes[i].button.trailingAnchor).isActive = true
            self.gameScenes[i].view.topAnchor.constraint(equalTo: self.gameScenes[i].button.topAnchor).isActive = true
            self.gameScenes[i].view.bottomAnchor.constraint(equalTo: self.gameScenes[i].button.bottomAnchor).isActive = true
        }
        

        // Adding backButtonLabel as sub view to the backButtonView
        self.backButtonView.addSubview(self.backButtonLabel)

        // Setting constraints for backButtonLabel
        self.backButtonLabel.leadingAnchor.constraint(equalTo: self.backButtonView.leadingAnchor, constant: 3.0).isActive = true
        self.backButtonLabel.trailingAnchor.constraint(equalTo: self.backButtonView.trailingAnchor, constant: -3.0).isActive = true
        self.backButtonLabel.topAnchor.constraint(equalTo: self.backButtonView.topAnchor, constant: 3.0).isActive = true
        self.backButtonLabel.bottomAnchor.constraint(equalTo: self.backButtonView.bottomAnchor, constant: -3.0).isActive = true


        // Adding backButton as sub view to the backButtonView
        self.backButtonView.addSubview(self.backButton)

        // Setting constraints for backButton
        self.backButton.leadingAnchor.constraint(equalTo: self.backButtonView.leadingAnchor).isActive = true
        self.backButton.trailingAnchor.constraint(equalTo: self.backButtonView.trailingAnchor).isActive = true
        self.backButton.topAnchor.constraint(equalTo: self.backButtonView.topAnchor).isActive = true
        self.backButton.bottomAnchor.constraint(equalTo: self.backButtonView.bottomAnchor).isActive = true


        // Configuring second level UIStackView
        for i in 0 ..< self.gameScenes.count {
            self.secondStackView.addArrangedSubview(self.gameScenes[i].view)
        }
        self.secondStackView.axis = .vertical
        self.secondStackView.distribution = .fillEqually
        self.secondStackView.spacing = 30.0


        // Configuring first level UIStackView
        self.firstStackView.addArrangedSubview(self.secondStackView)
        self.firstStackView.addArrangedSubview(self.backButtonView)
        self.firstStackView.axis = .vertical
        self.firstStackView.distribution = .equalSpacing
        self.firstStackView.spacing = 30.0
        self.backgroundVibrancyView.contentView.addSubview(self.firstStackView)
        self.firstStackView.leadingAnchor.constraint(equalTo: self.backgroundVibrancyView.leadingAnchor, constant: 70.0).isActive = true
        self.firstStackView.trailingAnchor.constraint(equalTo: self.backgroundVibrancyView.trailingAnchor, constant: -70.0).isActive = true
        self.firstStackView.topAnchor.constraint(equalTo: self.backgroundVibrancyView.topAnchor, constant: 180.0).isActive = true
        self.firstStackView.bottomAnchor.constraint(equalTo: self.backgroundVibrancyView.bottomAnchor, constant: -180.0).isActive = true
        
    }
    
    
    // SceneSelectionButtons handler
    @objc private func sceneSelectionButtonTouchDown(sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect(filename: "PressButton.wav")
        UIView.animate(withDuration: 0.05) {
            self.gameScenes[sender.tag].view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
    }

    // SceneSelectionButtons release handler outside its borders
    @objc private func sceneSelectionButtonTouchUpOutside(sender: UIButton) {
        UIView.animate(withDuration: 0.05) {
            self.gameScenes[sender.tag].view.transform = .identity
        }
    }

    // SceneSelectionButtons release handler inside its borders
    @objc private func sceneSelectionButtonTouchUpInside(sender: UIButton) {
        // Saving selected game scene
        switch sender.tag {
        case 1:
            GameSettings.sharedInstance.selectedScene = .dark
        default:
            GameSettings.sharedInstance.selectedScene = .light
        }
        let gameViewController = GameViewController()
        gameViewController.modalPresentationStyle = .fullScreen
        gameViewController.modalTransitionStyle = .flipHorizontal
        self.present(gameViewController, animated: true, completion: nil)
        UIView.animate(withDuration: 0.05) {
            self.gameScenes[sender.tag].view.transform = .identity
        }
    }
    
    // BackButton handler
    @objc private func backButtonTouchDown(sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect(filename: "PressButton.wav")
        UIView.animate(withDuration: 0.05) {
            self.backButtonView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            self.backButtonView.alpha = 0.3
        }
    }
    
    // BackButton release handler outside its borders
    @objc private func backButtonTouchUpOutside(sender: UIButton) {
        UIView.animate(withDuration: 0.05) {
            self.backButtonView.transform = .identity
            self.backButtonView.alpha = 1.0
        }
    }
    
    // BackButton release handler inside its borders
    @objc private func backButtonTouchUpInside(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.05) {
            self.backButtonView.transform = .identity
            self.backButtonView.alpha = 1.0
        }
    }
    
}





// Creating a DifficultySelectionViewController class
final class DifficultySelectionViewController: UIViewController {
    
    // Overriding property that determine the ability to rotate the screen
    override var shouldAutorotate: Bool {
        return false
    }
    
    // Overriding property that define possible orientations
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    // Creating a constant storing background
    private let backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "Background_#1.png")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImageView
    }()
    
    // Create a visual blur effect for the background
    private let backgroundBlurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: .regular)
        blurView.isUserInteractionEnabled = true
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    // Create a vibrancy visual effect for the background
    private let backgroundVibrancyView: UIVisualEffectView = {
        let vibrancyView = UIVisualEffectView()
        vibrancyView.effect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .regular), style: .fill)
        vibrancyView.isUserInteractionEnabled = true
        vibrancyView.clipsToBounds = true
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        return vibrancyView
    }()
    
    // Creating the first level of UIStackView
    private let firstStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isUserInteractionEnabled = true
        stackView.clipsToBounds = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Creating the second level of UIStackView
    private let secondStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isUserInteractionEnabled = true
        stackView.clipsToBounds = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Create DifficultyLevel structure
    private struct DifficultyLevel {
        var view: UIView
        var label: UILabel
        var button: UIButton
    }
    
    // Declaring an array of DifficultyLevel
    private var difficultyLevels = [DifficultyLevel]()
    
    // Creating a UIView for the back button
    private let backButtonView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 8.0
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Create a UILabel for back button
    private let backButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "Main Menu"
        label.font = UIFont(name: "Helvetica Neue", size: 25.0)
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.isUserInteractionEnabled = true
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Create a back button
    private let backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTouchDown(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(backButtonTouchUpOutside(sender:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(backButtonTouchUpInside(sender:)), for: .touchUpInside)
        return button
    }()
    
    
    
    // Overriding "viewDidLoad" method
    override func viewDidLoad() {
        
        // Parent method call
        super.viewDidLoad()
        
        
        // Adding backgroundImageView as sub view to the main view
        self.view.addSubview(self.backgroundImageView)
        
        // Setting constraints for backgroundImageView
        self.backgroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.backgroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        // Adding backgroundBlurView as sub view to the backgroundImageView
        self.backgroundImageView.addSubview(self.backgroundBlurView)

        // Setting constraints for backgroundBlurView
        self.backgroundBlurView.leadingAnchor.constraint(equalTo: self.backgroundImageView.leadingAnchor).isActive = true
        self.backgroundBlurView.trailingAnchor.constraint(equalTo: self.backgroundImageView.trailingAnchor).isActive = true
        self.backgroundBlurView.topAnchor.constraint(equalTo: self.backgroundImageView.topAnchor).isActive = true
        self.backgroundBlurView.bottomAnchor.constraint(equalTo: self.backgroundImageView.bottomAnchor).isActive = true
        
        
        // Adding backgroundVibrancyView as content view to the backgroundBlurView
        self.backgroundBlurView.contentView.addSubview(self.backgroundVibrancyView)
        
        // Setting constraints for backgroundVibrancyView
        self.backgroundVibrancyView.leadingAnchor.constraint(equalTo: self.backgroundBlurView.leadingAnchor).isActive = true
        self.backgroundVibrancyView.trailingAnchor.constraint(equalTo: self.backgroundBlurView.trailingAnchor).isActive = true
        self.backgroundVibrancyView.topAnchor.constraint(equalTo: self.backgroundBlurView.topAnchor).isActive = true
        self.backgroundVibrancyView.bottomAnchor.constraint(equalTo: self.backgroundBlurView.bottomAnchor).isActive = true
        
        
        // Filling an array with elements
        for _ in 0 ... 2 {
            self.difficultyLevels.append(DifficultyLevel(view: UIView(), label: UILabel(), button: UIButton(type: .custom)))
        }
        
        
        // Setting the view field of the structure
        for i in 0 ..< self.difficultyLevels.count {
            self.difficultyLevels[i].view.isUserInteractionEnabled = true
            self.difficultyLevels[i].view.clipsToBounds = true
            self.difficultyLevels[i].view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        // Setting the label field of the structure
        for i in 0 ..< self.difficultyLevels.count {
            self.difficultyLevels[i].view.addSubview(self.difficultyLevels[i].label)
            self.difficultyLevels[i].label.font = UIFont(name: "Helvetica Neue", size: 40.0)
            self.difficultyLevels[i].label.font = UIFont.boldSystemFont(ofSize: 40.0)
            self.difficultyLevels[i].label.textAlignment = .center
            self.difficultyLevels[i].label.baselineAdjustment = .alignCenters
            self.difficultyLevels[i].label.isUserInteractionEnabled = true
            self.difficultyLevels[i].label.clipsToBounds = true
            self.difficultyLevels[i].label.translatesAutoresizingMaskIntoConstraints = false
            self.difficultyLevels[i].label.leadingAnchor.constraint(equalTo: self.difficultyLevels[i].view.leadingAnchor).isActive = true
            self.difficultyLevels[i].label.trailingAnchor.constraint(equalTo: self.difficultyLevels[i].view.trailingAnchor).isActive = true
            self.difficultyLevels[i].label.topAnchor.constraint(equalTo: self.difficultyLevels[i].view.topAnchor).isActive = true
            self.difficultyLevels[i].label.bottomAnchor.constraint(equalTo: self.difficultyLevels[i].view.bottomAnchor).isActive = true
        }
        self.difficultyLevels[0].label.text = "EASY"
        self.difficultyLevels[1].label.text = "MEDIUM"
        self.difficultyLevels[2].label.text = "HARD"
        
        
        // Setting the button field of the structure
        for i in 0 ..< self.difficultyLevels.count {
            self.difficultyLevels[i].view.addSubview(self.difficultyLevels[i].button)
            self.difficultyLevels[i].button.tag = i
            self.difficultyLevels[i].button.isUserInteractionEnabled = true
            self.difficultyLevels[i].button.clipsToBounds = true
            self.difficultyLevels[i].button.translatesAutoresizingMaskIntoConstraints = false
            self.difficultyLevels[i].button.addTarget(self, action: #selector(difficultyButtonTouchDown(sender:)), for: .touchDown)
            self.difficultyLevels[i].button.addTarget(self, action: #selector(difficultyButtonTouchUpOutside(sender:)), for: .touchUpOutside)
            self.difficultyLevels[i].button.addTarget(self, action: #selector(difficultyButtonTouchUpInside(sender:)), for: .touchUpInside)
            self.difficultyLevels[i].view.leadingAnchor.constraint(equalTo: self.difficultyLevels[i].button.leadingAnchor).isActive = true
            self.difficultyLevels[i].view.trailingAnchor.constraint(equalTo: self.difficultyLevels[i].button.trailingAnchor).isActive = true
            self.difficultyLevels[i].view.topAnchor.constraint(equalTo: self.difficultyLevels[i].button.topAnchor).isActive = true
            self.difficultyLevels[i].view.bottomAnchor.constraint(equalTo: self.difficultyLevels[i].button.bottomAnchor).isActive = true
        }
        
        // Adding backButtonLabel as sub view to the backButtonView
        self.backButtonView.addSubview(self.backButtonLabel)

        // Setting constraints for backButtonLabel
        self.backButtonLabel.leadingAnchor.constraint(equalTo: self.backButtonView.leadingAnchor).isActive = true
        self.backButtonLabel.trailingAnchor.constraint(equalTo: self.backButtonView.trailingAnchor).isActive = true
        self.backButtonLabel.topAnchor.constraint(equalTo: self.backButtonView.topAnchor).isActive = true
        self.backButtonLabel.bottomAnchor.constraint(equalTo: self.backButtonView.bottomAnchor).isActive = true


        // Adding backButton as sub view to the backButtonView
        self.backButtonView.addSubview(self.backButton)

        // Setting constraints for backButton
        self.backButton.leadingAnchor.constraint(equalTo: self.backButtonView.leadingAnchor).isActive = true
        self.backButton.trailingAnchor.constraint(equalTo: self.backButtonView.trailingAnchor).isActive = true
        self.backButton.topAnchor.constraint(equalTo: self.backButtonView.topAnchor).isActive = true
        self.backButton.bottomAnchor.constraint(equalTo: self.backButtonView.bottomAnchor).isActive = true
        
        
        // Configuring second level UIStackView
        for i in 0 ..< self.difficultyLevels.count {
            self.secondStackView.addArrangedSubview(self.difficultyLevels[i].view)
        }
        self.secondStackView.axis = .vertical
        self.secondStackView.distribution = .fillEqually
        self.secondStackView.spacing = 20.0
        
        
        // Configuring first level UIStackView
        self.firstStackView.addArrangedSubview(self.secondStackView)
        self.firstStackView.addArrangedSubview(self.backButtonView)
        self.firstStackView.axis = .vertical
        self.firstStackView.distribution = .fillProportionally
        self.firstStackView.spacing = 70.0
        self.backgroundVibrancyView.contentView.addSubview(self.firstStackView)
        self.firstStackView.centerXAnchor.constraint(equalTo: self.backgroundVibrancyView.centerXAnchor).isActive = true
        self.firstStackView.centerYAnchor.constraint(equalTo: self.backgroundVibrancyView.centerYAnchor, constant: 40.0).isActive = true
        self.firstStackView.widthAnchor.constraint(equalToConstant: 100.0)
        self.firstStackView.heightAnchor.constraint(equalToConstant: 100.0)
        
    }
    
    
    // DifficultyButtons handler
    @objc private func difficultyButtonTouchDown(sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect(filename: "PressButton.wav")
        UIView.animate(withDuration: 0.05) {
            self.difficultyLevels[sender.tag].view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
    }
    
    // DifficultyButtons release handler outside its borders
    @objc private func difficultyButtonTouchUpOutside(sender: UIButton) {
        UIView.animate(withDuration: 0.05) {
            self.difficultyLevels[sender.tag].view.transform = .identity
        }
    }
    
    // DifficultyButtons release handler inside its borders
    @objc private func difficultyButtonTouchUpInside(sender: UIButton) {
        // Saving selected difficulty
        switch sender.tag {
        case 1:
            GameSettings.sharedInstance.difficulty = .medium
        case 2:
            GameSettings.sharedInstance.difficulty = .hard
        default:
            GameSettings.sharedInstance.difficulty = .easy
        }
        let gameSceneSelectionViewController = GameSceneSelectionViewController()
        gameSceneSelectionViewController.modalPresentationStyle = .fullScreen
        gameSceneSelectionViewController.modalTransitionStyle = .flipHorizontal
        self.present(gameSceneSelectionViewController, animated: true, completion: nil)
        UIView.animate(withDuration: 0.05) {
            self.difficultyLevels[sender.tag].view.transform = .identity
        }
    }
    
    // BackButton handler
    @objc private func backButtonTouchDown(sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect(filename: "PressButton.wav")
        UIView.animate(withDuration: 0.05) {
            self.backButtonView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            self.backButtonView.alpha = 0.3
        }
    }
    
    // BackButton release handler outside its borders
    @objc private func backButtonTouchUpOutside(sender: UIButton) {
        UIView.animate(withDuration: 0.05) {
            self.backButtonView.transform = .identity
            self.backButtonView.alpha = 1.0
        }
    }
    
    // BackButton release handler inside its borders
    @objc private func backButtonTouchUpInside(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.05) {
            self.backButtonView.transform = .identity
            self.backButtonView.alpha = 1.0
        }
    }
    
}





// Creating a MainViewController class
final class MainViewController: UIViewController {
    
    // Overriding property that determine the ability to rotate the screen
    override var shouldAutorotate: Bool {
        return false
    }
    
    // Overriding property that define possible orientations
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    // Creating a constant storing background
    private let backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "Background_#1.png")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImageView
    }()
    
    // Create a visual blur effect for the background
    private let backgroundBlurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView()
        blurView.effect = UIBlurEffect(style: .regular)
        blurView.isUserInteractionEnabled = true
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    // Create a vibrancy visual effect for the background
    private let backgroundVibrancyView: UIVisualEffectView = {
        let vibrancyView = UIVisualEffectView()
        vibrancyView.effect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .regular), style: .fill)
        vibrancyView.isUserInteractionEnabled = true
        vibrancyView.clipsToBounds = true
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        return vibrancyView
    }()
    
    // Creating a UIView for a button
    private let playButtonView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 10.0
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Creating a UILabel for a button
    private let playButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "Play Leap-Boy"
        label.font = UIFont(name: "Helvetica Neue", size: 30.0)
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.isUserInteractionEnabled = true
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Creating a UIButton
    private let playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playButtonTouchDown(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(playButtonTouchUpOutside(sender:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(playButtonTouchUpInside(sender:)), for: .touchUpInside)
        return button
    }()
    
    
    // Overriding "viewDidLoad" method
    override func viewDidLoad() {
        
        // Parent method call
        super.viewDidLoad()
        
        
        SKTAudio.sharedInstance().playBackgroundMusic(filename: "Background.mp3")
        
        
        // Adding backgroundImageView as sub view to the main view
        self.view.addSubview(self.backgroundImageView)
        
        // Setting constraints for backgroundImageView
        self.backgroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.backgroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        // Adding backgroundBlurView as sub view to the backgroundImageView
        self.backgroundImageView.addSubview(self.backgroundBlurView)

        // Setting constraints for backgroundBlurView
        self.backgroundBlurView.leadingAnchor.constraint(equalTo: self.backgroundImageView.leadingAnchor).isActive = true
        self.backgroundBlurView.trailingAnchor.constraint(equalTo: self.backgroundImageView.trailingAnchor).isActive = true
        self.backgroundBlurView.topAnchor.constraint(equalTo: self.backgroundImageView.topAnchor).isActive = true
        self.backgroundBlurView.bottomAnchor.constraint(equalTo: self.backgroundImageView.bottomAnchor).isActive = true
        
        
        // Adding backgroundVibrancyView as content view to the backgroundBlurView
        self.backgroundBlurView.contentView.addSubview(self.backgroundVibrancyView)
        
        // Setting constraints for backgroundVibrancyView
        self.backgroundVibrancyView.leadingAnchor.constraint(equalTo: self.backgroundBlurView.leadingAnchor).isActive = true
        self.backgroundVibrancyView.trailingAnchor.constraint(equalTo: self.backgroundBlurView.trailingAnchor).isActive = true
        self.backgroundVibrancyView.topAnchor.constraint(equalTo: self.backgroundBlurView.topAnchor).isActive = true
        self.backgroundVibrancyView.bottomAnchor.constraint(equalTo: self.backgroundBlurView.bottomAnchor).isActive = true
        
        
        // Adding playButtonView as content view to the backgroundVibrancyView
        self.backgroundVibrancyView.contentView.addSubview(self.playButtonView)
        
        // Setting constraints for backgroundVibrancyView
        self.playButtonView.centerXAnchor.constraint(equalTo: self.backgroundVibrancyView.centerXAnchor).isActive = true
        self.playButtonView.centerYAnchor.constraint(equalTo: self.backgroundVibrancyView.centerYAnchor).isActive = true
        self.playButtonView.widthAnchor.constraint(equalToConstant: 224.0).isActive = true
        self.playButtonView.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        
        // Adding playButtonLabel as sub view to the playButtonView
        self.playButtonView.addSubview(self.playButtonLabel)

        // Setting constraints for playButtonLabel
        self.playButtonLabel.leadingAnchor.constraint(equalTo: self.playButtonView.leadingAnchor).isActive = true
        self.playButtonLabel.trailingAnchor.constraint(equalTo: self.playButtonView.trailingAnchor).isActive = true
        self.playButtonLabel.topAnchor.constraint(equalTo: self.playButtonView.topAnchor).isActive = true
        self.playButtonLabel.bottomAnchor.constraint(equalTo: self.playButtonView.bottomAnchor).isActive = true
        
        
        // Adding playButton as sub view to the playButtonView
        self.playButtonView.addSubview(self.playButton)
        
        // Setting constraints for playButton
        self.playButton.leadingAnchor.constraint(equalTo: self.playButtonView.leadingAnchor).isActive = true
        self.playButton.trailingAnchor.constraint(equalTo: self.playButtonView.trailingAnchor).isActive = true
        self.playButton.topAnchor.constraint(equalTo: self.playButtonView.topAnchor).isActive = true
        self.playButton.bottomAnchor.constraint(equalTo: self.playButtonView.bottomAnchor).isActive = true
        
        
    }
    
    
    // PlayButton handler
    @objc private func playButtonTouchDown(sender: UIButton) {
        SKTAudio.sharedInstance().playSoundEffect(filename: "PressButton.wav")
        UIView.animate(withDuration: 0.05) {
            self.playButtonView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            self.playButtonView.alpha = 0.3
        }
    }
    
    // PlayButton release handler outside its borders
    @objc private func playButtonTouchUpOutside(sender: UIButton) {
        UIView.animate(withDuration: 0.05) {
            self.playButtonView.transform = .identity
            self.playButtonView.alpha = 1.0
        }
    }
    
    // PlayButton release handler inside its borders
    @objc private func playButtonTouchUpInside(sender: UIButton) {
        let difficultySelectionViewController = DifficultySelectionViewController()
        difficultySelectionViewController.modalPresentationStyle = .fullScreen
        difficultySelectionViewController.modalTransitionStyle = .flipHorizontal
        self.present(difficultySelectionViewController, animated: true, completion: nil)
        UIView.animate(withDuration: 0.05) {
            self.playButtonView.transform = .identity
            self.playButtonView.alpha = 1.0
        }
    }
    
}





// MARK: - Customize the display of the starting UIViewController
PlaygroundSupport.PlaygroundPage.current.liveView = MainViewController()
//PlaygroundSupport.PlaygroundPage.current.liveView = DifficultySelectionViewController()
//PlaygroundSupport.PlaygroundPage.current.liveView = GameSceneSelectionViewController()
//PlaygroundSupport.PlaygroundPage.current.liveView = GameViewController()





/*
 
 http://opengameart.org
 http://gameart2d.com
 
 */
