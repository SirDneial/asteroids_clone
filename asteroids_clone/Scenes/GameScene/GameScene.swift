//
//  GameScene.swift
//  asteroids_clone
//
//  Created by Daniel Rivera on 4/29/24.
//

import SpriteKit

class GameScene: SKScene {
    
    //Player
    let player: Player = Player(imageNamed: "ship-still")
    
    //Enemy SpaceShip
    let enemy: EnemyShip = EnemyShip(imageNamed: "alien-ship")
    
    let thrustSound = SKAction.repeatForever(SKAction.playSoundFileNamed("thrust.wav", waitForCompletion: true))
    
    override func didMove(to view: SKView) {
        createPlayer()
        enemy.enemyTimer = Double.random(in: 1800...7200) // at 60 fps its 30...120 seconds
    }
    
    override func update(_ currentTime: TimeInterval) {
        playerIsRotating()
        playerIsThrusting()
        wrapPlayerInFrame()
        
        spawnEnemy()
        if !enemy.isEnemyMoving {
            enemyMovement()
        }
        wrapEnemyInFrame()
        if enemy.isEnemyAlive {
            enemy.shootTimer += 1
            if enemy.shootTimer == 27 {
                enemy.shoot()
                enemy.shootTimer = 0
            }
        }
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0, 123:
            player.isRotatingLeft = true
            player.isRotatingRight = false
        case 2, 124:
            player.isRotatingLeft = false
            player.isRotatingRight = true
        case 49:
            player.isThrustOn = true
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
            player.isRotatingLeft = false
            player.isRotatingRight = false
        case 2, 124:
            player.isRotatingLeft = false
            player.isRotatingRight = false
        case 49:
            player.isThrustOn = false
            player.texture = SKTexture(imageNamed: "ship-still")
            scene?.removeAction(forKey: "thrustSound")
        default:
            break
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        createPlayerBullet()
    }
    
    func createPlayer() {
        guard childNode(withName: "player") == nil else { return }
        player.setup()
        addChild(player)
    }
    
    func createEnemy() {
        guard childNode(withName: "enemy") == nil else { return }
        enemy.setup(score: player.Score)
        addChild(enemy)
    }
    
    func animateHyperSpace() {
        let tpSound = SKAction.playSoundFileNamed("hyperspace.wav", waitForCompletion: false)
        let outAnimation: SKAction = SKAction(named: "outAnimation")!
        let inAnimation: SKAction = SKAction(named: "inAnimation")!
        let randX = CGFloat.random(in: 100...1948)
        let randY = CGFloat.random(in: 150...1436)
        let stopShooting = SKAction.run { [self] in player.isHyperSpaceOn = true }
        let startShooting = SKAction.run { [self] in player.isHyperSpaceOn = false }
        let movePlayer = SKAction.move(to: CGPoint(x: randX, y: randY), duration: 0)
        let wait = SKAction.wait(forDuration: 0.40)
        let animation = SKAction.sequence([stopShooting, tpSound, outAnimation, wait, movePlayer, wait, inAnimation, startShooting])
        player.run(animation)
    }
    
    func createPlayerBullet() {
        guard player.isHyperSpaceOn == false && player.isPlayerAlive == true else { return }
        player.shoot(rotation: player.rotation)
    }
    
    fileprivate func playerIsRotating() {
        if player.isRotatingLeft {
            player.rotation += rotationFactor
            if player.rotation == 360 { player.rotation = 0 }
        } else if player.isRotatingRight {
            player.rotation -= rotationFactor
            if player.rotation < 0 { player.rotation = 360 - rotationFactor }
        }
    }
    
    fileprivate func playerIsThrusting() {
        player.move()
    }
    
    fileprivate func wrapPlayerInFrame() {
        player.validatePosition(width: frame.width, height: frame.height)
    }
    
    fileprivate func spawnEnemy() {
        if enemy.isEnemyAlive == false {
            if enemy.enemyTimer < 0 {
                createEnemy()
            } else {
                enemy.enemyTimer -= 1
            }
        }
    }
    
    fileprivate func wrapEnemyInFrame() {
        enemy.validatePosition(height: frame.height)
    }
    
    func enemyMovement() {
        if enemy.isEnemyAlive {
            enemy.isEnemyMoving = enemy.move()
        }
    }
}
