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
        physicsWorld.gravity = CGVector.zero
        let fishAnimatedAtlas = SKTextureAtlas(named: "Fish")
        var walkFrames = [SKTexture]()
        
        let numImages = fishAnimatedAtlas.textureNames.count
        for i in 1...numImages/2 {
            let fishTextureName = "salmon\(i)"
            walkFrames.append(fishAnimatedAtlas.textureNamed(fishTextureName))
        }
        
        walkingFrames = walkFrames
        walkingFish()
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
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
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "shark")
        monster.xScale = -1.0
        // Determine where to spawn the monster along the Y axis
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: CGFloat(actualY))
        
        // Add the monster to the scene
        addChild(monster)
        
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
        monster.physicsBody?.isDynamic = true // 2
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(3.0), max: CGFloat(6.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()

        monster.run(SKAction.sequence([actionMove, actionMoveDone]))
        
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
