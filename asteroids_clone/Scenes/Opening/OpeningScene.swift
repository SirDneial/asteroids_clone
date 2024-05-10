//
//  OpeningScene.swift
//  asteroids_clone
//
//  Created by Daniel Rivera on 5/1/24.
//

import SpriteKit

class OpeningScene: SKScene {
    
    private var background: SKSpriteNode?
    private var labelHighScore: SKLabelNode?
    private var labelStart: SKLabelNode?
    private var labelReset: SKLabelNode?
    
    var highScore: Int = 0 {
        didSet {
            labelHighScore?.text = String(format: "%05d", highScore)
        }
    }
    
    override func didMove(to view: SKView) {
        setupLabels()
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let clickedNodes = nodes(at: location)
        guard let clicked = clickedNodes.first else { return }
        
        if clicked.name == "labelStart" {
            openGameScene()
        } else if clicked.name == "labelReset" {
            resetHighScore()
        } else {
            animateStartLabel()
        }
    }
    
    fileprivate func openGameScene() {
        if let nextScene = SKScene(fileNamed: "GameScene") {
            nextScene.scaleMode = self.scaleMode
            let transition = SKTransition.reveal(with: .left, duration: 1)
            
            UserDefaults.standard.setValue(0, forKey: userdefaults.score)
            UserDefaults.standard.setValue(1, forKey: userdefaults.level)
            UserDefaults.standard.setValue(3, forKey: userdefaults.lives)
            
            view?.presentScene(nextScene, transition: transition)
        }
    }
    
    fileprivate func resetHighScore() {
        highScore = 0
        UserDefaults.standard.setValue(0, forKeyPath: userdefaults.highScore)
    }
    
    func setupLabels() {
        background = self.childNode(withName: "background") as? SKSpriteNode
        labelHighScore = self.childNode(withName: "labelHighScore") as? SKLabelNode
        labelStart = self.childNode(withName: "labelStart") as? SKLabelNode
        labelReset = self.childNode(withName: "labelReset") as? SKLabelNode
        
        labelStart?.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        labelReset?.position = CGPoint(x: frame.width - 300, y: 100)
        
        highScore = UserDefaults.standard.integer(forKey: "highScore")
    }
    
    func animateStartLabel() {
        let expand = SKAction.scale(to: 1.5, duration: 0.5)
        let rotate = SKAction.rotate(byAngle: deg2rad(degrees: -360), duration: 0.5)
        let contract = SKAction.scale(to: 1.0, duration: 0.5)
        labelStart?.run(SKAction.sequence([expand, rotate, contract]))
    }
}
