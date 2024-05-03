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
    var isThrustOn = false
    var isHyperSpaceOn = false
    
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
    let thrustFactor: CGFloat = 1.0 //bigger number = faster thrust
    let thrustSound = SKAction.repeatForever(SKAction.playSoundFileNamed("thrust.wav", waitForCompletion: true))
    
    override func didMove(to view: SKView) {
        createPlayer(atX: frame.width / 2, atY: frame.height / 2)
    }
    
    override func update(_ currentTime: TimeInterval) {
        playerIsRotating()
        playerIsThrusting()
        wrapPlayerInFrame()
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0, 123:
            isRotatingLeft = true
            isRotatingRight = false
        case 2, 124:
            isRotatingLeft = false
            isRotatingRight = true
        case 49:
            isThrustOn = true
            player.texture = SKTexture(imageNamed: "ship-moving")
            scene?.run(thrustSound, withKey: "thrustSound")
        case 13, 126:
            animateHyperSpace()
        default:
            break;
        }
    }
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 0, 123:
            isRotatingLeft = false
            isRotatingRight = false
        case 2, 124:
            isRotatingLeft = false
            isRotatingRight = false
        case 49:
            isThrustOn = false
            player.texture = SKTexture(imageNamed: "ship-still")
            scene?.removeAction(forKey: "thrustSound")
        default:
            break
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        createPlayerBullet()
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
    
    func animateHyperSpace() {
        let outAnimation: SKAction = SKAction(named: "outAnimation")!
        let inAnimation: SKAction = SKAction(named: "inAnimation")!
        let randX = CGFloat.random(in: 100...1948)
        let randY = CGFloat.random(in: 150...1436)
        let stopShooting = SKAction.run { self.isHyperSpaceOn = true }
        let startShooting = SKAction.run { self.isHyperSpaceOn = false }
        let movePlayer = SKAction.move(to: CGPoint(x: randX, y: randY), duration: 0)
        let wait = SKAction.wait(forDuration: 0.25)
        let animation = SKAction.sequence([stopShooting, outAnimation, wait, movePlayer, wait, inAnimation, startShooting])
        player.run(animation)
    }
    
    func createPlayerBullet() {
        guard isHyperSpaceOn == false && isPlayerAlive == true else { return }
        let bullet = SKShapeNode(ellipseOf: CGSize(width: 3, height: 3))
        let shotSound = SKAction.playSoundFileNamed("fire.wav", waitForCompletion: true)
        let move = SKAction.move(to: findDestination(start: player.position, angle: rotation), duration: 0.5)
        let seq = SKAction.sequence([shotSound, move, .removeFromParent()])
        bullet.position = player.position
        bullet.zPosition = 0
        bullet.fillColor = .white
        bullet.name = "playerBullet"
        addChild(bullet)
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 3)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.isDynamic = true
        bullet.run(seq)
    }
    
    fileprivate func playerIsRotating() {
        if isRotatingLeft {
            rotation += rotationFactor
            if rotation == 360 { rotation = 0 }
        } else if isRotatingRight {
            rotation -= rotationFactor
            if rotation < 0 { rotation = 360 - rotationFactor }
        }
    }
    
    fileprivate func playerIsThrusting() {
        if isThrustOn {
            xVector = sin(player.zRotation) * -thrustFactor
            yVector = cos(player.zRotation) * thrustFactor
            rotationVector = CGVector(dx: xVector, dy: yVector)
            player.physicsBody?.applyImpulse(rotationVector)
        }
    }
    
    fileprivate func wrapPlayerInFrame() {
        if player.position.y > frame.height { player.position.y = 0 }
        if player.position.y < 0 { player.position.y = frame.height }
        if player.position.x > frame.width { player.position.x = 0 }
        if player.position.x < 0 { player.position.x = frame.width }
    }
}
