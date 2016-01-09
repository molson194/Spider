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
    
    init(scene:GameScene, startPos:Int,endPos:Int,cards:[Card]) {
        sPosition = startPos
        ePosition = endPos
        cardsMoved = cards
        myScene = scene
        flipLast = false
    }
    
    func undo() {
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
    
    func redo() {
        for card in cardsMoved.reverse() {
            myScene.fieldCards[sPosition].removeLast()
            myScene.fieldCards[ePosition].append(card)
            
            let numCards = myScene.fieldCards[ePosition].count
            card.zPosition = CGFloat(numCards);
            let action = SKAction.moveTo(CGPoint(x:CGFloat(ePosition)*myScene.width/10+myScene.width/20,y:myScene.height-CGFloat(25*(numCards-1))),duration:0.1);
            card.runAction(action)
        }
        if flipLast {
            myScene.fieldCards[sPosition].last!.texture = SKTexture(imageNamed: String(format: "Cards/%@%d.png",(myScene.fieldCards[sPosition].last?.suit)!,(myScene.fieldCards[sPosition].last?.value)!))
            myScene.fieldCards[sPosition].last!.isFlipped = false
        }
    }
}