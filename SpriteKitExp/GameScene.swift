//
//  GameScene.swift
//  SpriteKitExp
//
//  Created by Alex Cao on 1/24/17.
//  Copyright © 2017 Alex Cao. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //var lastTouch: CGPoint? = nil

    var background = SKSpriteNode(imageNamed: "bgimage")
    
    override func didMove(to view: SKView) {

        backgroundColor = SKColor.blue
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        addChild(background)
        loadPlayer()
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.05)
        let fishAnimatedAtlas = SKTextureAtlas(named: "Fish")
        var walkFrames = [SKTexture]()
        
        let numImages = fishAnimatedAtlas.textureNames.count
        for i in 1...numImages/2 {
            let fishTextureName = "salmon\(i)"
            walkFrames.append(fishAnimatedAtlas.textureNamed(fishTextureName))
        }
        
        walkingFrames = walkFrames
        walkingFish()
        
    }
    
    func walkingFish
        () {
        //This is our general runAction method to make our bear walk.
        playerFish.run(SKAction.repeatForever(
            SKAction.animate(with: walkingFrames,
                                         timePerFrame: 0.5,
                                         resize: false,
                                         restore: true)),
                       withKey:"walkingInPlaceFish")
    }
    
    var walkingFrames : [SKTexture]!
    
    func loadPlayer() {
        self.addChild(playerFish)
        playerFish.physicsBody = SKPhysicsBody(rectangleOf: playerFish.size) // 1
        playerFish.physicsBody?.isDynamic = true // 2
    }
    
    lazy var playerFish: KGPlayerShipNode = {
        let shipNode = KGPlayerShipNode()
        shipNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        shipNode.name = "PlayerShip"
        return shipNode
    }()
    
    override func update(_ currentTime: CFTimeInterval) {
        // Called before each frame is rendered
        playerFish.update(interval: currentTime)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        if let destintation = touches.first as UITouch! {
            playerFish.touchPoint = destintation
            playerFish.travelling = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerFish.travelling = false
    }

    
}
