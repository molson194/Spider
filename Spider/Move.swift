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
        king.zPosition = 35 + CGFloat(myScene.decksComplete)
        let action = SKAction.moveTo(CGPoint(x:myScene.width/14+30*CGFloat(myScene.decksComplete),y:myScene.width/14), duration: 0.5);
        king.runAction(action)
        myScene.decksComplete++
        if flipLast {
            myScene.fieldCards[sPosition].last!.texture = SKTexture(imageNamed: String(format: "Cards/%@%d.png",(myScene.fieldCards[sPosition].last?.suit)!,(myScene.fieldCards[sPosition].last?.value)!))
            myScene.fieldCards[sPosition].last!.isFlipped = false
        }

        
    }
}