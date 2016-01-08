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
    var myScene: GameScene
    
    init(scene:GameScene, image: NSImage, suit: String, value: Int) {
        self.myScene = scene
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
    
    func isDone(column:Int) -> Bool {
        let currFieldColumn = myScene.fieldCards[column]
        let suit = currFieldColumn.last?.suit
        var value = 1
        for currCard in currFieldColumn.reverse() {
            if (currCard.value != value) || (currCard.suit != suit){
                return false
            }
            if value==13 {
                return true
            }
            value++
        }
        return false
    }
    // TODO back side image
    
    func canPlace(column:Int) -> Bool {
        if column>9 || column<0 {
            return false
        }
        let currFieldColumn = myScene.fieldCards[column]
        if currFieldColumn.count == 0 {
            return true
        }
        if (currFieldColumn.last?.value)!-1 == self.value {
            return true
        } else {
            return false
        }
    }
    
    
    func canMoveFunc() -> Bool {
        let currFieldColumn = myScene.fieldCards[Int(startPosition)]
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
            var currFieldCards = myScene.fieldCards
            while currFieldCards[Int(startPosition)].last! != self {
                currMoveCards.append(currFieldCards[Int(startPosition)].removeLast())
            }
            currMoveCards.append(currFieldCards[Int(startPosition)].removeLast())
            myScene.fieldCards = currFieldCards
        }
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        if canMove {
            var i=0
            for moveCard in currMoveCards {
                let action = SKAction.moveTo(CGPoint(x:theEvent.locationInWindow.x,y:theEvent.locationInWindow.y-30-CGFloat(i*25)),duration:0);
                moveCard.zPosition = CGFloat(50+i);
                moveCard.runAction(action)
                i--
            }
        }
    }
    
    override func mouseUp(theEvent: NSEvent) {
        if canMove {
            var currFieldCards = myScene.fieldCards
            var x = floor(theEvent.locationInWindow.x/125)
            if !canPlace(Int(x)) {
                x = startPosition
            }
            for moveCard in currMoveCards.reverse() {
                currFieldCards[Int(x)].append(moveCard)
                let numCards = currFieldCards[Int(x)].count
                moveCard.zPosition = CGFloat(numCards);
                let action = SKAction.moveTo(CGPoint(x:x*125+80,y:CGFloat(700 - 25*(numCards-1))),duration:0.1);
                moveCard.runAction(action)
            }
            currMoveCards = [Card]()
            if isDone(Int(x)) {
                for _ in 1...12 {
                //increment number of decks done, move the king to corner, if number of decks done is 8 game over
                    let card = currFieldCards[Int(x)].removeLast()
                    card.removeFromParent()
                    
                }
                //TODO move king
            }
            myScene.fieldCards = currFieldCards
        }
    }
    
}