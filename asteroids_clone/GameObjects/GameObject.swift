//
//  GameObject.swift
//  asteroids_clone
//
//  Created by Daniel Rivera on 5/3/24.
//

import SpriteKit

protocol GameObject where Self: SKSpriteNode {
    
    var rotation: CGFloat { get set }
    
    func setup()
    func move()
}
