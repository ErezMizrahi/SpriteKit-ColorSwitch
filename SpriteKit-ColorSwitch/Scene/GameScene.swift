//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Erez Mizrahi on 13/10/2020.
//

import SpriteKit
import UIKit

class GameScene: SKScene {
    
    var colorCircle: SKSpriteNode!
    var colorSwitchState: ColorSwitchState = .red
    var currentColorIndex: Int?
    
    let scoreLabel: SKLabelNode = SKLabelNode(text: "0")
    var score = 0
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
        
    }
    
    func setupPhysics() {
        //change scene gravity
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.8)
        
        //set delegete to detect contacts
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        //change background
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        //create the circle color switch entity
        colorCircle = SKSpriteNode(imageNamed: "colorCircle")
        //set size
        colorCircle.size = CGSize(width: frame.width / 3, height: frame.width / 3)
        //set position on screen
        colorCircle.position = CGPoint(x: frame.midX, y: frame.minY + colorCircle.size.height)
        //set z position
        colorCircle.zPosition = ZPositions.colorCircle
        //MARK:- add physics to the entity
        //create a physics body of circle shape around the entity
        colorCircle.physicsBody = SKPhysicsBody(circleOfRadius: colorCircle.size.width/2)
        //define the categorey of the entity
        colorCircle.physicsBody?.categoryBitMask = PhysicsCategories.switchCategorey
        //disable any dynamic force affect on the entity.. including gravity
        colorCircle.physicsBody?.isDynamic = false
        
        addChild(colorCircle)
        
        //label setup
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = .white
        
        //set position
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        //set z position
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
        spawnBall()
    }
    
    func turnWheel() {
      
        
        
        colorCircle.run(.rotate(byAngle: .pi/2 , duration: 0.25)) {[weak self] in
            guard let self = self else { return }
            guard let newState = ColorSwitchState(rawValue: self.colorSwitchState.rawValue + 1) else {
                self.colorSwitchState = .red
                return;
            }
                self.colorSwitchState = newState
        }
        
    }
    
    func gameOver(){
        guard let view = self.view else { return }
        
        //save scores
        UserDefaults.standard.set(score, forKey: "RecentScore")
        if score > UserDefaults.standard.integer(forKey: "HighestScore") {
            UserDefaults.standard.set(score, forKey: "HighestScore")
        }
        

        let menuScene = MenuScene(size: view.bounds.size)
        view.presentScene(menuScene)
    }
    
    func spawnBall() {
        //create a random number between 0,3
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        let size = CGSize(width: 25.0, height: 25.0)
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.color[currentColorIndex!], size: size)
        //make sure color is applyed in the texture
        ball.colorBlendFactor = 1.0
        //set name
        ball.name = "ball"
        //set the position
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        //set z position
        ball.zPosition = ZPositions.ball
        //MARK:- add physics to the entity
        //create a physics body of circle shape around the entity
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        //define the categorey of the entity
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategorey
        //set the contactTestBitMask to the colorCircle categoryBitMask to detect when the ball hit the colorCircle
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategorey
        //set the collisionBitMask to none so the ball wont collide with the colorCircle
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        addChild(ball)
    }
    
    func updateScoreLabel() {
        self.scoreLabel.text = "\(score)"
        self.scoreLabel.run(.fadeOut(withDuration: 0.5)) {[weak self] in
            self?.scoreLabel.run(.fadeIn(withDuration: 0.5))
        }
    }
    
    
    //detect touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
}


extension GameScene: SKPhysicsContactDelegate {
    
    //always get called when a contact is registerd in the scene
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case PhysicsCategories.ballCategorey | PhysicsCategories.switchCategorey:
            if let ball = contact.bodyA.node?.name == "ball" ?
                contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                if currentColorIndex == colorSwitchState.rawValue {
                    //update score
                    self.score += 1
                    self.updateScoreLabel()
                    
                    ball.run(.fadeOut(withDuration: 0.25)) {[weak self] in
                        //remove from the scene and dealoc the node
                        ball.removeFromParent()
                        self?.spawnBall()
                    }
                } else {
                    gameOver()
                }
            }
        default:
            break;
        }
    }
}
