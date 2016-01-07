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
    var currMoveCards: [Card]
    
    init(image: NSImage, suit: String, value: Int) {
        self.suit = suit
        self.value = value
        self.startPosition = 0
        self.canMove = false
        self.currMoveCards = [Card]()
        let texture = SKTexture(image: image)
        super.init(texture: texture, color: NSColor.clearColor(), size: CGSizeMake(100, 150))
        self.userInteractionEnabled = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Card.isDone with stack
    // back side image
    
    func canPlace(column:Int) -> Bool {
        if column>9 || column<0 {
            return false
        }
        let currFieldColumn = GameScene().getFieldCards()[column]
        
        if (currFieldColumn.last?.value)!-1 == self.value || currFieldColumn.count == 0 {
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
            while currFieldCards[Int(startPosition)].last! != self {
                currMoveCards.append(currFieldCards[Int(startPosition)].last!)
                currFieldCards[Int(startPosition)].removeLast()
            }
            currMoveCards.append(currFieldCards[Int(startPosition)].last!)
            currFieldCards[Int(startPosition)].removeLast()
            GameScene().setFieldCards(currFieldCards)
        }
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        if canMove {
            var i=0
            for moveCard in currMoveCards {
                let action = SKAction.moveTo(CGPoint(x:theEvent.locationInWindow.x,y:theEvent.locationInWindow.y-CGFloat(i*35)),duration:0);
                moveCard.zPosition = CGFloat(50+i);
                moveCard.runAction(action)
                i--
            }
        }
    }
    
    override func mouseUp(theEvent: NSEvent) {
        if canMove {
            var currFieldCards = GameScene().getFieldCards()
            var x = floor(theEvent.locationInWindow.x/125)
            if !canPlace(Int(x)) {
                x = startPosition
            }
            for moveCard in currMoveCards.reverse() {
                let numCards = currFieldCards[Int(x)].count
                moveCard.zPosition = CGFloat(numCards);
                currFieldCards[Int(x)].append(moveCard)
                let action = SKAction.moveTo(CGPoint(x:x*125+80,y:CGFloat(700 - 35*numCards)),duration:0.1);
                moveCard.runAction(action)
            }
            currMoveCards = [Card]()
            GameScene().setFieldCards(currFieldCards)
        }
    }
    
}