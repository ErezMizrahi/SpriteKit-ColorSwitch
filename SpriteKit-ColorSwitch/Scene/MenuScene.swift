//
//  MenuScene.swift
//  ColorSwitch
//
//  Created by Erez Mizrahi on 14/10/2020.
//

import SpriteKit

class MenuScene: SKScene {
    override func didMove(to view: SKView) {
        //change background
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)

        addLogo()
        addLabels()
    }
    
    func addLogo() {
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.size = CGSize(width: frame.width/2, height: frame.width/2)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + frame.width/2)
        addChild(logo)
    }
    
    func addLabels() {
        let playLabel = SKLabelNode(text: "Tap to play")
        let highScoreLabel = SKLabelNode(text: "Highest score: \(UserDefaults.standard.integer(forKey: "HighestScore"))")
        let recentScoreLabel = SKLabelNode(text: "Recent score:\(UserDefaults.standard.integer(forKey: "RecentScore"))")
        
        // set positions
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - highScoreLabel.frame.size.height * 4)
        recentScoreLabel.position = CGPoint(x: frame.midX, y: highScoreLabel.position.y - recentScoreLabel.frame.size.height * 2)
        
        //style
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontSize = 50.0
        playLabel.fontColor = .white
        highScoreLabel.fontName = "AvenirNext-Bold"
        highScoreLabel.fontSize = 35.0
        highScoreLabel.fontColor = .white
        recentScoreLabel.fontName = "AvenirNext-Bold"
        recentScoreLabel.fontSize = 35.0
        recentScoreLabel.fontColor = .white
        addChild(playLabel)
        addChild(highScoreLabel)
        addChild(recentScoreLabel)

        animate(label: playLabel)
    }
    
    func animate(label: SKLabelNode) {
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        
        let sequnce = SKAction.sequence([scaleUp, scaleDown])
        label.run(.repeatForever(sequnce))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = self.view else { return }
        let gameScene = GameScene(size: view.bounds.size)
        view.presentScene(gameScene)
    }
}
