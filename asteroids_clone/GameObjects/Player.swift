//
//  Player.swift
//  asteroids_clone
//
//  Created by Daniel Rivera on 5/3/24.
//

import SpriteKit

class Player: SKSpriteNode {
    
    var thrustFactor: CGFloat = 1.0 //bigger number = faster thrust
    var rotation: CGFloat = 0 {
        didSet {
            zRotation = deg2rad(degrees: rotation)
        }
    }

    private var _isPlayerAlive = false
    private var _isRotatingLeft = false
    private var _isRotatingRight = false
    private var _isThrustOn = false
    private var _isHyperSpaceOn = false
    var _score = startingScore
    var _lives = startingLives
    
    func setup() {
        self.position = CGPoint(x: 1024, y: 768)
        self.zPosition = 0
        self.size = CGSize(width: 120, height: 120)
        self.name = "player"
        self.texture = SKTexture(imageNamed: "ship-still")
        self.physicsBody = SKPhysicsBody(texture: self.texture ?? SKTexture(imageNamed: "ship-still"), size: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = 0.2
        self.physicsBody?.allowsRotation = false
        self.isPlayerAlive = true
        rotation = 0
    }
    
    func shoot(rotation: CGFloat) {
        let pos = CGPoint(x: self.position.x, y: self.position.y)
        let bullet = SKShapeNode(ellipseOf: CGSize(width: 3, height: 3))
        let shotSound = SKAction.playSoundFileNamed("fire.wav", waitForCompletion: true)
        let move = SKAction.move(to: findDestination(start: pos, angle: rotation), duration: 0.75)
        let seq = SKAction.sequence([move, .removeFromParent()])
        bullet.position = pos
        bullet.zPosition = 0
        bullet.fillColor = .white
        bullet.name = "playerBullet"
        scene!.addChild(bullet)
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 3)        
        bullet.physicsBody?.categoryBitMask = CollisionType.playerBullet.rawValue
        bullet.physicsBody?.collisionBitMask = CollisionType.asteroid.rawValue | CollisionType.enemy.rawValue
        bullet.physicsBody?.contactTestBitMask = CollisionType.asteroid.rawValue | CollisionType.enemy.rawValue
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.isDynamic = true
        bullet.run(shotSound)
        bullet.run(seq)
    }
    
    func move() {
        if isThrustOn {
            self.texture = SKTexture(imageNamed: "ship-moving")
            let xVector = sin(self.zRotation) * -thrustFactor
            let yVector = cos(self.zRotation) * thrustFactor
            let rotationVector = CGVector(dx: xVector, dy: yVector)
            self.physicsBody?.applyImpulse(rotationVector)
        } else {
            self.texture = SKTexture(imageNamed: "ship-still")
        }
    }
    
    func validatePosition(width: CGFloat, height: CGFloat) {
        if self.position.y > height { self.position.y = 0 }
        if self.position.y < 0 { self.position.y = height }
        if self.position.x > width { self.position.x = 0 }
        if self.position.x < 0 { self.position.x = width }
    }
    
    var isPlayerAlive: Bool {
        get {
            return _isPlayerAlive
        }
        set {
            _isPlayerAlive = newValue
        }
    }
    
    var isRotatingLeft: Bool {
        get {
            return _isRotatingLeft
        }
        set {
            _isRotatingLeft = newValue
        }
    }
    
    var isRotatingRight: Bool {
        get {
            return _isRotatingRight
        }
        set {
            _isRotatingRight = newValue
        }
    }
    
    var isThrustOn: Bool {
        get {
            return _isThrustOn
        }
        set {
            _isThrustOn = newValue
        }
    }
    
    var isHyperSpaceOn: Bool {
        get {
            return _isHyperSpaceOn
        }
        set {
            _isHyperSpaceOn = newValue
        }
    }
    
    var Score: Int {
        get {
            return _score
        }
        set {
            _score = newValue
        }
    }
    
    var Lives: Int {
        get {
            return _lives
        }
        set {
            _lives = newValue
        }
    }
}
