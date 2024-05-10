//
//  GameScene.swift
//  asteroids_clone
//
//  Created by Daniel Rivera on 4/29/24.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Game Props
    var score: Int = 0
    var level: Int = 1
    
    //Player
    let player: Player = Player(imageNamed: "ship-still")
    
    //Enemy SpaceShip
    let enemy: EnemyShip = EnemyShip(imageNamed: "alien-ship")
    
    //Asteroid
    var maxAsteroid: Int = 0
    var totalAsteroid: Int = 0
    
    let thrustSound = SKAction.repeatForever(SKAction.playSoundFileNamed("thrust.wav", waitForCompletion: true))
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        createPlayer()
        enemy.enemyTimer = Double.random(in: 1800...7200) // at 60 fps its 30...120 seconds
        maxAsteroid = level > 4 ? 11 : 2 + (level * 2)
        spawnAsteroids()
    }
    
    override func update(_ currentTime: TimeInterval) {
        playerIsRotating()
        playerIsThrusting()
        wrapPlayerInFrame()
        
        updateEnemyState()
        
        updateAsteroidState()
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }
        
        if firstNode.name == "asteroid-large" || firstNode.name == "asteroid-medium" || firstNode.name == "asteroid-small" {
            if secondNode.name == "enemy-large" || secondNode.name == "enemy-small" || secondNode.name == "enemyBullet" {
                //asteroid hit enemy/enemy bullet
                breakAsteroid(node: firstNode, name: firstNode.name!, posiiton: firstNode.position)
                destroyNode(node: secondNode, name: secondNode.name!)
            } else if secondNode.name == "player" || secondNode.name == "playerBullet" {
                //asteroid hit player/player bullet
                breakAsteroid(node: firstNode, name: firstNode.name!, posiiton: firstNode.position)
                destroyNode(node: secondNode, name: secondNode.name!)
            }
        } else if firstNode.name == "enemy-large" || firstNode.name == "enemy-small" {
            //enemy hit player/player bullet
            destroyNode(node: firstNode, name: firstNode.name!)
            destroyNode(node: secondNode, name: secondNode.name!)
        } else {
            //enemy bullet hit player
            destroyNode(node: firstNode, name: firstNode.name!)
            destroyNode(node: secondNode, name: secondNode.name!)
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
        let bullet = player.shoot(rotation: player.rotation)
        wrapBulletInFrame(bullet: bullet)
    }
    
    fileprivate func wrapBulletInFrame(bullet: SKShapeNode) {
        if bullet.position.y > frame.height { bullet.position.y = 0 }
        if bullet.position.y < 0 { bullet.position.y = frame.height }
        if bullet.position.x > frame.width { bullet.position.x = 0 }
        if bullet.position.x < 0 { bullet.position.x = frame.width }
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
        enemy.validatePosition(width: frame.width, height: frame.height)
    }
    
    fileprivate func updateEnemyState() {
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
    
    fileprivate func spawnAsteroids() {
        for _ in 1...maxAsteroid {
            let randomX: CGFloat = CGFloat.random(in: 0...2048)
            let randomY: CGFloat = CGFloat.random(in: 0...1636)
            let asteroid: Asteroid = Asteroid(imageNamed: "asteroid1")
            asteroid.setup(atX: randomX, atY: randomY, withWidth: 240, withHeight: 240, withName: "asteroid-large")
            addChild(asteroid)
            totalAsteroid += 1
        }
    }
    
    fileprivate func updateAsteroidState() {
        for node in self.children {
            if let asteroid: Asteroid = node as? Asteroid {
                asteroid.move()
                asteroid.validatePosition(width: frame.width, height: frame.height)
            }
        }
    }
    
    func enemyMovement() {
        if enemy.isEnemyAlive {
            enemy.isEnemyMoving = enemy.move()
        }
    }
    
    func breakAsteroid(node: SKNode, name: String, posiiton: CGPoint) {
        let sound = SKAction.playSoundFileNamed(name == "asteroid-large" ? "bangLarge.wav" : name == "asteroid-medium" ? "bangMedium.wav" : "bangSmall.wav", waitForCompletion: false)
        let create = SKAction.run {
            for _ in 0...1 {
                let newAstroid: Asteroid = Asteroid(imageNamed: "asteroid1")
                newAstroid.setup(atX: posiiton.x, atY: posiiton.y, withWidth: name == "asteroid-large" ? 120 : 60, withHeight: name == "asteroid-large" ? 120 : 60, withName: name == "asteroid-large" ? "asteroid-medium" : "asteroid-small")
                self.addChild(newAstroid)
            }
        }
        let destory = SKAction.run { self.destroyNode(node: node, name: name) }
        let group = SKAction.group([sound, destory])
        let seq = SKAction.sequence([group, create])
        
        if name == "asteroid-large" || name == "asteroid-medium" {
            scene?.run(seq)
            totalAsteroid += 1
        } else {
            scene?.run(group)
            totalAsteroid -= 1
        }
    }
    
    fileprivate func destroyNode(node: SKNode, name: String) {
        if name == "player" {
            node.physicsBody?.contactTestBitMask = 0
            let explode = SKAction(named: "explode")!
            let seq = SKAction.sequence([explode, .removeFromParent()])
            node.run(seq)
            node.name = ""
            player.isPlayerAlive = false
        } else if name == "enemy-large" || name == "enemy-small" {
            node.removeFromParent()
            node.name = ""
            let sound = SKAction.playSoundFileNamed(name == "enemy-large" ? "bangLarge.wav" : "bangSmall.wav", waitForCompletion: false)
            enemy.isEnemyAlive = false
            enemy.enemyTimer = Double.random(in: 1800...7200)
            scene?.run(sound)
        } else {
            node.removeFromParent()
            node.name = ""
        }
    }
}
