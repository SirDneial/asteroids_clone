//
//  EnemyShip.swift
//  asteroids_clone
//
//  Created by Daniel Rivera on 5/3/24.
//

import SpriteKit

class EnemyShip: SKSpriteNode {
    
    var _isEnemyAlive = false
    var _isEnemyBig = true
    var _enemyTimer: Double = 0
    
    var isEnemyAline: Bool {
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

}
