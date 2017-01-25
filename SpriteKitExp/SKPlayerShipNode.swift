//
//  SKPlayerShipNode.swift
//  SpriteKitExp
//
//  Created by Alex Cao on 1/25/17.
//  Copyright © 2017 Alex Cao. All rights reserved.
//

//
//  KGPlayerShipNode.swift
//  KType
//
//  Created by Kyle Goddard on 2015-03-26.
//  Copyright (c) 2015 Kyle Goddard. All rights reserved.
//

import SpriteKit

class KGPlayerShipNode: SKSpriteNode {
    
    var touchPoint: UITouch?
    var lastInterval: CFTimeInterval?
    var travelling: Bool
    let brakeDistance:CGFloat = 4.0
    let defaultShipSpeed = 250;
    
    let defaultScale:CGFloat = 0.5
    let defaultTextureName = "salmon1"
    let defaultSize:CGSize = CGSize(width: 300.0, height: 150.0)
    
    init() {
        
        let texture = SKTexture(imageNamed: defaultTextureName)
        let color = UIColor.red
        let size = defaultSize
        
        travelling = false
        
        super.init(texture: texture, color: color, size: size)
        
        loadDefaultParams()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadDefaultParams() {
        self.xScale = defaultScale
        self.yScale = defaultScale
    }
    
    func travelTowardsPoint(point: CGPoint, byTimeDelta timeDelta: TimeInterval) {
        var shipSpeed = defaultShipSpeed
        
        var distanceLeft = sqrt(pow(position.x - point.x, 2) + pow(position.y - point.y, 2))
        
        if (distanceLeft > brakeDistance) {
            var distanceToTravel = CGFloat(timeDelta) * CGFloat(shipSpeed)
            var angle = atan2(point.y - position.y, point.x - position.x)
            var yOffset = distanceToTravel * sin(angle)
            var xOffset = distanceToTravel * cos(angle)
            
            position = CGPoint(x: position.x + xOffset, y: position.y + yOffset)
        }
    }
    
    func update(interval: CFTimeInterval) {
        
        if lastInterval == nil {
            lastInterval = interval
        }
        
        var delta: CFTimeInterval = interval - lastInterval!
        
        if (travelling) {
            if let destination = touchPoint?.location(in: (scene as? GameScene)!) {
                travelTowardsPoint(point: destination, byTimeDelta: delta)
            }
        }
        lastInterval = interval
    }
    
}

