//
//  EnemyShip.swift
//  asteroids_clone
//
//  Created by Daniel Rivera on 5/3/24.
//

import SpriteKit

class EnemyShip: SKSpriteNode {
    
    fileprivate var _isEnemyAlive = false
    fileprivate var _isEnemyBig = true
    fileprivate var _isEnemyMoving = false
    fileprivate var _enemyTimer: Double = 0
    fileprivate var _shootTimer: Double = 0
    fileprivate var startOnLeft = Bool.random()
    
    func setup(score: Int) {
        self.isEnemyAlive = true
        let startY = Double.random(in: 150...1436)
        self.isEnemyBig = score > 40000 ? false : Bool.random()
        self.position = startOnLeft ? CGPoint(x: -100, y: startY) : CGPoint(x: 2248, y: startY)
        self.size = CGSize(width: self.isEnemyBig ? 120 : 60, height: self.isEnemyBig ? 120 : 60)
        self.name = self.isEnemyBig ? "enemy-large" : "enemy-small"
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
    }
    
    func move() -> Bool {
        let firstMove = SKAction.move(to: startOnLeft ? CGPoint(x: 716, y: self.position.y + Double.random(in: -500...500)) : CGPoint(x: 1432, y: self.position.y + Double.random(in: -500...500)), duration: 3)
        let secondMove = SKAction.move(to: startOnLeft ? CGPoint(x: 1432, y: self.position.y + Double.random(in: -500...500)) : CGPoint(x: 716, y: self.position.y + Double.random(in: -500...500)), duration: 3)
        let thirdMove = SKAction.move(to: startOnLeft ? CGPoint(x: 2049, y: self.position.y + Double.random(in: -500...500)) : CGPoint(x: -100, y: self.position.y + Double.random(in: -500...500)), duration: 3)
        let remove = SKAction.run {
            self.isEnemyMoving = false
            self.isEnemyAlive = false
            self.enemyTimer = Double.random(in: 1800...7200)
        }
        
        let sound = SKAction.repeatForever(SKAction.playSoundFileNamed(self.isEnemyBig ? "saucerBig.wav" : "saucerSmall.wav", waitForCompletion: true))
        let seq = SKAction.sequence([firstMove, secondMove, thirdMove, .removeFromParent(), remove])
        let group = SKAction.group([sound, seq])
        self.run(group)
        return true
    }
    
    func shoot() {
        let pos = CGPoint(x: self.position.x, y: self.position.y)
        let bullet = SKShapeNode(ellipseOf: CGSize(width: 3, height: 3))
        let shotSound = SKAction.playSoundFileNamed("fire.wav", waitForCompletion: true)
        let move = SKAction.move(to: findDestination(start: pos, angle: CGFloat.random(in: 0...360)), duration: 0.5)
        let seq = SKAction.sequence([move, .removeFromParent()])
        bullet.position = pos
        bullet.zPosition = 0
        bullet.fillColor = .white
        bullet.name = "enemyBullet"
        scene!.addChild(bullet)
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 3)
        bullet.run(shotSound)
        bullet.run(seq)
    }
    
    func validatePosition(height: CGFloat) {
        if self.position.y > height { self.position.y = 0 }
        if self.position.y < 0 { self.position.y = height }
    }
    
    var isEnemyAlive: Bool {
        get {
            return _isEnemyAlive
        }
        set {
            _isEnemyAlive = newValue
        }
    }
    
    var isEnemyBig: Bool {
        get {
            return _isEnemyBig
        }
        set {
            _isEnemyBig = newValue
        }
    }
    
    var enemyTimer: Double {
        get {
            return _enemyTimer
        }
        set(newValue) {
            _enemyTimer = newValue
        }
    }
    
    var shootTimer: Double {
        get {
            return _shootTimer
        }
        set {
            _shootTimer = newValue
        }
    }

    var isEnemyMoving: Bool {
        get {
            return _isEnemyMoving
        }
        set {
            _isEnemyMoving = newValue
        }
    }
}
