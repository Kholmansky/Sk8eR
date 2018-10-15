//
//  Skater.swift
//  Sk8er
//
//  Created by Maxim Kholmansky on 12/10/2018.
//  Copyright © 2018 Maxim Kholmansky. All rights reserved.
//

import SpriteKit

class Skater: SKSpriteNode {

    var velocity = CGPoint.zero
    var minimumY: CGFloat = 0.0
    var jumpSpeed: CGFloat = 20.0
    var isOnGround = true
    
    func setupPhysicalBody() {
        
        if let skaterTexture = texture {
            physicsBody = SKPhysicsBody(texture: <#T##SKTexture#>, size: <#T##CGSize#>)
        }
    }
}
