//
//  Move.swift
//  Spider
//
//  Created by Matthew Olson on 1/8/16.
//  Copyright © 2016 Molson. All rights reserved.
//

import Foundation
import SpriteKit

class Move: NSObject {
    var sPosition: Int
    var ePosition: Int
    var cardsMoved: [Card]
    var myScene: GameScene
    var flipLast: Bool
    var moveType: String
    
    init(scene:GameScene, type:String, startPos:Int,endPos:Int,cards:[Card]) {
        sPosition = startPos
        moveType = type
        ePosition = endPos
        cardsMoved = cards
        myScene = scene
        flipLast = false
    }
    
    func undoShift() {
        if flipLast {
            myScene.fieldCards[sPosition].last!.texture = SKTexture(imageNamed: "CardBack")
            myScene.fieldCards[sPosition].last!.isFlipped = true
        }
        
        for card in cardsMoved.reverse() {
            myScene.fieldCards[ePosition].removeLast()
            myScene.fieldCards[sPosition].append(card)
            
            let numCards = myScene.fieldCards[sPosition].count
            card.zPosition = CGFloat(numCards);
            let action = SKAction.moveTo(CGPoint(x:CGFloat(sPosition)*myScene.width/10+myScene.width/20,y:myScene.height-myScene.width/15-CGFloat(25*(numCards-1))),duration:0.1);
            card.runAction(action)
        }
    }
    
    func undoKing() {
        if flipLast {
            myScene.fieldCards[sPosition].last!.texture = SKTexture(imageNamed: "CardBack")
            myScene.fieldCards[sPosition].last!.isFlipped = true
        }
        let kingCard = cardsMoved.last
        myScene.fieldCards[sPosition].append(kingCard!)
        var numCards = myScene.fieldCards[sPosition].count
        kingCard!.zPosition = CGFloat(numCards);
        let action = SKAction.moveTo(CGPoint(x:CGFloat(sPosition)*myScene.width/10+myScene.width/20,y:myScene.height-myScene.width/15-CGFloat(25*(numCards-1))),duration:0.1);
        kingCard!.runAction(action)
        for i in 1...12 {
            let card = cardsMoved[12-i]
            myScene.fieldCards[sPosition].append(card)
            numCards = myScene.fieldCards[sPosition].count
            card.position = CGPointMake(myScene.width/10*CGFloat(sPosition)+myScene.width/20,myScene.height-myScene.width/15-CGFloat(25*(numCards-1)))
            myScene.addChild(card)
        }
        myScene.cannotSelectKings.removeLast()
        myScene.decksComplete--
    }
    
    func undoDeal() {
        if myScene.deck.count == 0 {
            let dealCard = DealCard.init(scene: myScene)
            dealCard.zPosition = 1
            dealCard.name = "Deal Card"
            myScene.addChild(dealCard)
            myScene.cardsLeft.text = "5"
            myScene.cardsLeft.zPosition = 1
            myScene.cardsLeft.fontSize = 15
            myScene.cardsLeft.position = CGPoint(x:myScene.width*13/14-75, y:30)
            myScene.addChild(myScene.cardsLeft)
        }
        for i in 0...9 {
            let card = myScene.fieldCards[i].removeLast()
            card.removeFromParent()
        }
        var newDeck = [Card]()
        for card in cardsMoved {
            newDeck.append(card)
        }
        for card in myScene.deck {
            newDeck.append(card)
        }
        myScene.deck = newDeck
        myScene.cardsLeft.text = String(format:"%d",myScene.deck.count/10)
    }
    
    func redoShift() {
        for card in cardsMoved.reverse() {
            myScene.fieldCards[sPosition].removeLast()
            myScene.fieldCards[ePosition].append(card)
            
            let numCards = myScene.fieldCards[ePosition].count
            card.zPosition = CGFloat(numCards);
            let action = SKAction.moveTo(CGPoint(x:CGFloat(ePosition)*myScene.width/10+myScene.width/20,y:myScene.height-myScene.width/15-CGFloat(25*(numCards-1))),duration:0.1);
            card.runAction(action)
        }
        if flipLast {
            myScene.fieldCards[sPosition].last!.texture = SKTexture(imageNamed: String(format: "Cards/%@%d.png",(myScene.fieldCards[sPosition].last?.suit)!,(myScene.fieldCards[sPosition].last?.value)!))
            myScene.fieldCards[sPosition].last!.isFlipped = false
        }
    }
    
    func redoKing() {
        for _ in 0...11 {
            let card = myScene.fieldCards[sPosition].removeLast()
            card.removeFromParent()
        }
        let king = myScene.fieldCards[sPosition].removeLast()
        myScene.cannotSelectKings.append(king)
        king.zPosition = 2 + CGFloat(myScene.decksComplete)
        let action = SKAction.moveTo(CGPoint(x:myScene.width/14+30*CGFloat(myScene.decksComplete),y:myScene.width/14), duration: 0.5);
        king.runAction(action)
        myScene.decksComplete++
        if flipLast {
            myScene.fieldCards[sPosition].last!.texture = SKTexture(imageNamed: String(format: "Cards/%@%d.png",(myScene.fieldCards[sPosition].last?.suit)!,(myScene.fieldCards[sPosition].last?.value)!))
            myScene.fieldCards[sPosition].last!.isFlipped = false
        }
    }
    
    func redoDeal() {
        for i in 0...9 {
            let card = myScene.deck.removeFirst()
            myScene.fieldCards[i].append(card)
            let numCards = myScene.fieldCards[i].count
            card.zPosition = CGFloat(numCards)
            card.position = CGPointMake(myScene.width/10*CGFloat(i)+myScene.width/20,myScene.height-myScene.width/15-CGFloat(25*(numCards-1)))
            myScene.addChild(card)
            myScene.cardsLeft.text = String(format:"%d",myScene.deck.count/10)
        }
        if myScene.deck.count == 0 {
            myScene.cardsLeft.removeFromParent()
            myScene.childNodeWithName("Deal Card")?.removeFromParent()
        }
        
    }
}