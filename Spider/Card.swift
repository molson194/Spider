//
//  Card.swift
//  Spider
//
//  Created by Matthew Olson on 1/6/16.
//  Copyright © 2016 Molson. All rights reserved.
//

import Foundation
import SpriteKit
import Cocoa

class Card: SKSpriteNode {
    var suit: String
    var value: Int
    var startPosition: CGFloat
    
    init(imageName: String, suit: String, value: Int) {
        self.suit = suit
        self.value = value
        self.startPosition = 0
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: NSColor.clearColor(), size: CGSizeMake(100, 200))
        self.userInteractionEnabled = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Card.isDone with stack
    // Card.canMove() - Boolean Check below
    // Card.canPlace(Card) --> Bool
    // back side image
    
    
    //Set current position
    
    override func mouseDown(theEvent: NSEvent) {
        //Save original spot
        startPosition = theEvent.locationInWindow.x
        startPosition = floor(startPosition/125)
        var currFieldCards = GameScene().getFieldCards()
        currFieldCards[Int(startPosition)].removeLast()
        GameScene().setFieldCards(currFieldCards)
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        //Check to see if can move
        let action = SKAction.moveTo(CGPoint(x:theEvent.locationInWindow.x,y:theEvent.locationInWindow.y),duration:0);
        self.zPosition = 50;
        self.runAction(action)
    }
    
    override func mouseUp(theEvent: NSEvent) {
        // if can place, move from array and put in right spot, else put back to original spot, set z position
        if false {
            var x = theEvent.locationInWindow.x
            x = floor(x/125)*125+80
            // TODO bug outside of view
            let action = SKAction.moveTo(CGPoint(x:x,y:200),duration:0.1);
            self.runAction(action)
        } else {
            let action = SKAction.moveTo(CGPoint(x:startPosition*125+80,y:200),duration:0.1);
            self.runAction(action)
        }
        
    }
    
}