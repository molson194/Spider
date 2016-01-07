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
    var canMove:Bool
    
    init(imageName: String, suit: String, value: Int) {
        self.suit = suit
        self.value = value
        self.startPosition = 0
        self.canMove = false
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: NSColor.clearColor(), size: CGSizeMake(100, 200))
        self.userInteractionEnabled = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Card.isDone with stack
    // back side image
    
    func canPlace(column:Int) -> Bool {
        let currFieldColumn = GameScene().getFieldCards()[column]
        if (currFieldColumn.last?.value)!-1 == self.value {
            return true
        } else {
            return false
        }
    }
    
    
    func canMoveFunc() -> Bool {
        let currFieldColumn = GameScene().getFieldCards()[Int(startPosition)]
        var hasMetCard = false
        var prevCard = self
        for currCard in currFieldColumn {
            if hasMetCard {
                if (currCard.value != prevCard.value - 1) || (currCard.suit != prevCard.suit){
                    return false
                }
                prevCard = currCard
            }
            if self==currCard {
                hasMetCard = true
            }
            
        }
        return true;
    }
    
    override func mouseDown(theEvent: NSEvent) {
        startPosition = theEvent.locationInWindow.x
        startPosition = floor(startPosition/125)
        canMove = canMoveFunc()
        if canMove {
            var currFieldCards = GameScene().getFieldCards()
            currFieldCards[Int(startPosition)].removeLast()
            GameScene().setFieldCards(currFieldCards)
        }
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        if canMove {
            let action = SKAction.moveTo(CGPoint(x:theEvent.locationInWindow.x,y:theEvent.locationInWindow.y),duration:0);
            self.zPosition = 50;
            self.runAction(action)
        }
    }
    
    override func mouseUp(theEvent: NSEvent) {
        if canMove {
            var currFieldCards = GameScene().getFieldCards()
            let x = floor(theEvent.locationInWindow.x/125)
            if canPlace(Int(x)) {
                let numCards = currFieldCards[Int(x)].count
                self.zPosition = CGFloat(numCards);
                currFieldCards[Int(x)].append(self)
                // TODO bug outside of view
                let action = SKAction.moveTo(CGPoint(x:x*125+80,y:CGFloat(650 - 35*numCards)),duration:0.1);
                self.runAction(action)
            } else {
                let numCards = currFieldCards[Int(startPosition)].count
                self.zPosition = CGFloat(numCards);
                currFieldCards[Int(startPosition)].append(self)
                let action = SKAction.moveTo(CGPoint(x:startPosition*125+80,y:CGFloat(650 - 35*numCards)),duration:0.1);
                self.runAction(action)
            }
            GameScene().setFieldCards(currFieldCards)
        }
    }
    
}