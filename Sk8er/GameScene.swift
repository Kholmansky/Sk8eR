//
//  GameScene.swift
//  Sk8er
//
//  Created by Maxim Kholmansky on 12/10/2018.
//  Copyright © 2018 Maxim Kholmansky. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var bricks = [SKSpriteNode]()
    var brickSize = CGSize.zero
    var scrollSpeed: CGFloat = 5.0
    let gravitySpeed: CGFloat = 1.5
    var lastUpdateTime: TimeInterval?

    let skater = Skater(imageNamed: "skater")

    override func didMove(to view: SKView) {

        anchorPoint = CGPoint.zero

        let background = SKSpriteNode(imageNamed: "background")
        let xMid = frame.midX
        let yMid = frame.midY
        background.position = CGPoint(x: xMid, y: yMid)
        addChild(background)
        resetSkater()
        addChild(skater)

        let tapMethod = #selector(self.handleTap(tapGesture:))
        let tapGesture = UITapGestureRecognizer(target: self, action: tapMethod)
        view.addGestureRecognizer(tapGesture)
    }

    func resetSkater() {
        let skaterX: CGFloat = frame.midX / 2.0
        let skaterY: CGFloat = skater.frame.height / 2.0 + 64.0
        self.skater.position = CGPoint(x: skaterX, y: skaterY)
        self.skater.zPosition = 10
        self.skater.minimumY = skaterY
    }

    func spawnBrick(atPosition position: CGPoint) -> SKSpriteNode {

        let brick = SKSpriteNode(imageNamed: "sidewalk")
        brick.position = position
        brick.zPosition = 8
        addChild(brick)

        self.brickSize = brick.size
        self.bricks.append(brick)

        return brick
    }

    func updateBrick(withScrollAmount currentScrollAmount: CGFloat) {

        var farthestRightBrickX: CGFloat = 0.0

        for brick in self.bricks {

            let newX = brick.position.x - currentScrollAmount

            if newX < -self.brickSize.width {

                brick.removeFromParent()

                if let brickIndex = self.bricks.index(of: brick) {
                    self.bricks.remove(at: brickIndex)
                }
            } else {
                brick.position = CGPoint(x: newX, y: brick.position.y)

                if brick.position.x > farthestRightBrickX {
                    farthestRightBrickX = brick.position.x
                }
            }
        }

        while farthestRightBrickX < frame.width {
            var brickX = farthestRightBrickX + self.brickSize.width + 1.0
            let brixkY = self.brickSize.height / 2.0

            let randomNumber = arc4random_uniform(99)

            if randomNumber < 5 {
                let gap = 20.0 * self.scrollSpeed
                brickX += gap
            }

            let newBrick = spawnBrick(atPosition: CGPoint(x: brickX, y: brixkY))
            farthestRightBrickX = newBrick.position.x
        }
    }
    
    func updateSkater() {
        
        if false == self.skater.isOnGround {
            
            let velocityY = self.skater.velocity.y - self.gravitySpeed
            
            self.skater.velocity = CGPoint(x: self.skater.velocity.x, y: velocityY)
            
            let newSkaterY: CGFloat = self.skater.position.y + self.skater.velocity.y
            
            self.skater.position = CGPoint(x: self.skater.position.x, y: newSkaterY)
            
            if (self.skater.position.y < self.skater.minimumY) {
                
                self.skater.position.y = self.skater.minimumY
                self.skater.velocity = CGPoint.zero
                self.skater.isOnGround = true
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        var elapsedTime: TimeInterval = 0.0
        if let lastTimeStamp = self.lastUpdateTime {
            elapsedTime = currentTime - lastTimeStamp
        }
        self.lastUpdateTime = currentTime

        let expectedElapsedTime: TimeInterval = 1.0 / 60.0

        let scrollAdjustment = CGFloat( elapsedTime / expectedElapsedTime )
        let currentScrollAmount = self.scrollSpeed * scrollAdjustment

        updateBrick(withScrollAmount: currentScrollAmount)
        
        updateSkater()
    }

    @objc func handleTap(tapGesture: UITapGestureRecognizer) {

        if self.skater.isOnGround {

            self.skater.velocity = CGPoint(x: 0.0, y: self.skater.jumpSpeed)

            self.skater.isOnGround = false
        }
    }
}
