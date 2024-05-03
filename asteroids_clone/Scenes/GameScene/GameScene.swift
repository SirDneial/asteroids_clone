//
//  GameScene.swift
//  asteroids_clone
//
//  Created by Daniel Rivera on 4/29/24.
//

import SpriteKit

class GameScene: SKScene {
    
    //Player
    let player = SKSpriteNode(imageNamed: "ship-still")
    var isPlayerAlive = false
    var isRotatingLeft = false
    var isRotatingRight = false
    
    //Control
    var rotation: CGFloat = 0 {
        didSet {
            player.zRotation = deg2rad(degrees: rotation)
        }
    }
    let rotationFactor: CGFloat = 4 //bigger number = faster rotation
    var xVector: CGFloat = 0
    var yVector: CGFloat = 0
    var rotationVector: CGVector = .zero
    
    override func didMove(to view: SKView) {
        createPlayer(atX: frame.width / 2, atY: frame.height / 2)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isRotatingLeft {
            rotation += rotationFactor
            if rotation == 360 { rotation = 0 }
        } else if isRotatingRight {
            rotation -= rotationFactor
            if rotation < 0 { rotation = 360 - rotationFactor }
        }
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0:
            isRotatingLeft = true
            isRotatingRight = false
        case 2:
            isRotatingLeft = false
            isRotatingRight = true
        case 49:
            print("Boost")
        default:
            break;
        }
    }
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 0:
            isRotatingLeft = false
            isRotatingRight = false
        case 2:
            isRotatingLeft = false
            isRotatingRight = false
        case 49:
            print("boost released")
        default:
            break
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        print("Mouse clicked at \(location)")
    }
    
    func createPlayer(atX: Double, atY: Double) {
        guard childNode(withName: "player") == nil else { return }
        player.position = CGPoint(x: atX, y: atY)
        player.zPosition = 0
        player.size = CGSize(width: 120, height: 120)
        player.name = "player"
        player.texture = SKTexture(imageNamed: "ship-still")
        addChild(player)
        player.physicsBody = SKPhysicsBody(texture: player.texture ?? SKTexture(imageNamed: "ship-still"), size: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.mass = 0.2
        player.physicsBody?.allowsRotation = false
        isPlayerAlive = true
    }
}
