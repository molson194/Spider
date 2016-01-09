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
    var isFlipped:Bool
    var currMoveCards: [Card]
    var myScene: GameScene
    
    init(scene:GameScene, imageName: String, suit: String, value: Int) {
        self.myScene = scene
        self.suit = suit
        self.value = value
        self.startPosition = 0
        self.canMove = false
        self.isFlipped = false
        self.currMoveCards = [Card]()
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: NSColor.clearColor(), size: CGSizeMake(110, 150))
        self.userInteractionEnabled = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isDone(column:Int) -> Bool {
        let suit = myScene.fieldCards[column].last?.suit
        var value = 1
        for currCard in myScene.fieldCards[column].reverse() {
            if (currCard.value != value) || (currCard.suit != suit) || currCard.isFlipped {
                return false
            }
            if value==13 {
                return true
            }
            value++
        }
        return false
    }
    
    func canPlace(column:Int) -> Bool {
        if column>9 || column<0 {
            return false
        }
        if myScene.fieldCards[column].count == 0 {
            return true
        }
        if (myScene.fieldCards[column].last?.value)!-1 == self.value {
            return true
        } else {
            return false
        }
    }
    
    func canMoveFunc() -> Bool {
        if isFlipped {
            return false
        }
        var hasMetCard = false
        var prevCard = self
        for currCard in myScene.fieldCards[Int(startPosition)] {
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
        startPosition = theEvent.locationInNode(myScene).x
        startPosition = floor((startPosition-10)/125)
        canMove = canMoveFunc()
        if canMove {
            while myScene.fieldCards[Int(startPosition)].last != self {
                currMoveCards.append(myScene.fieldCards[Int(startPosition)].removeLast())
            }
            currMoveCards.append(myScene.fieldCards[Int(startPosition)].removeLast())
        }
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        if canMove {
            var i=0
            for moveCard in currMoveCards.reverse() {
                let action = SKAction.moveTo(CGPoint(x:theEvent.locationInNode(myScene).x,y:theEvent.locationInNode(myScene).y-40+CGFloat(i*25)),duration:0);
                moveCard.zPosition = CGFloat(50-i);
                moveCard.runAction(action)
                i--
            }
        }
    }
    
    override func mouseUp(theEvent: NSEvent) {
        if canMove {
            var x = floor(theEvent.locationInNode(myScene).x/125)
            if !canPlace(Int(x)) {
                x = startPosition
            } else {
                myScene.moves.append(Move(scene:myScene, startPos: Int(startPosition),endPos: Int(x),cards: currMoveCards))
            }
            for moveCard in currMoveCards.reverse() {
                myScene.fieldCards[Int(x)].append(moveCard)
                let numCards = myScene.fieldCards[Int(x)].count
                moveCard.zPosition = CGFloat(numCards);
                let action = SKAction.moveTo(CGPoint(x:x*125+80,y:CGFloat(650-25*(numCards-1))),duration:0.1);
                moveCard.runAction(action)
            }
            if myScene.fieldCards[Int(startPosition)].count>0 {
                if ((myScene.fieldCards[Int(startPosition)].last?.isFlipped) == true) {
                    myScene.fieldCards[Int(startPosition)].last?.texture = SKTexture(imageNamed: String(format: "Cards/%@%d.png",(myScene.fieldCards[Int(startPosition)].last?.suit)!,(myScene.fieldCards[Int(startPosition)].last?.value)!))
                    myScene.fieldCards[Int(startPosition)].last?.isFlipped = false
                    myScene.moves.last!.flipLast = true
                }
            }
            currMoveCards = [Card]()
            if isDone(Int(x)) {
                for _ in 1...12 {
                    let card = myScene.fieldCards[Int(x)].removeLast()
                    card.removeFromParent()
                }
                let card = myScene.fieldCards[Int(x)].removeLast()
                card.zPosition = 35 + CGFloat(myScene.decksComplete)
                let action = SKAction.moveTo(CGPoint(x:150+30*CGFloat(myScene.decksComplete),y:150), duration: 0.5);
                card.runAction(action)
                myScene.decksComplete++
                if myScene.fieldCards[Int(x)].count>0 {
                    if ((myScene.fieldCards[Int(x)].last?.isFlipped) == true) {
                        myScene.fieldCards[Int(x)].last?.texture = SKTexture(imageNamed: String(format: "Cards/%@%d.png",(myScene.fieldCards[Int(x)].last?.suit)!,(myScene.fieldCards[Int(x)].last?.value)!))
                        myScene.fieldCards[Int(x)].last?.isFlipped = false
                    }
                }
                if myScene.decksComplete == 8 {
                    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
                    myLabel.text = "You Win!"
                    myLabel.fontSize = 45
                    myLabel.position = CGPoint(x:CGRectGetMidX(myScene.frame), y:CGRectGetMidY(myScene.frame))
                    myScene.addChild(myLabel)
                }
            }
        }
    }
    
}