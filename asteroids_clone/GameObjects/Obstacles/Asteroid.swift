//
//  Asteroid.swift
//  asteroids_clone
//
//  Created by Daniel Rivera on 5/3/24.
//

import SpriteKit

class Asteroid: SKSpriteNode {
    
    var xMove: CGFloat = 0
    var yMove: CGFloat = 0
    
    func setup(atX x: CGFloat, atY y: CGFloat, withWidth: Int, withHeight: Int, withName name: String) {
        xMove = CGFloat.random(in: -2...4)
        yMove = CGFloat.random(in: -2...4)
        
        self.size = CGSize(width: withWidth, height: withHeight)
        self.position = CGPoint(x: x, y: y)
        self.zPosition = 0
        self.name = name
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.categoryBitMask = CollisionType.asteroid.rawValue
        self.physicsBody?.collisionBitMask = CollisionType.player.rawValue | CollisionType.playerBullet.rawValue | CollisionType.enemyBullet.rawValue | CollisionType.enemy.rawValue
        self.physicsBody?.contactTestBitMask = CollisionType.player.rawValue | CollisionType.playerBullet.rawValue | CollisionType.enemyBullet.rawValue | CollisionType.enemy.rawValue
    }
    
    func move() {
        self.position = CGPoint(x: self.position.x + xMove, y: self.position.y + yMove)
    }
    
    func validatePosition(width: CGFloat, height: CGFloat) {
        if self.position.y > height { self.position.y = 0 }
        if self.position.y < 0 { self.position.y = height }
        if self.position.x > width { self.position.x = 0 }
        if self.position.x < 0 { self.position.x = width }
    }
}
