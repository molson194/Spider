//
//  DealCard.swift
//  Spider
//
//  Created by Matthew Olson on 1/7/16.
//  Copyright © 2016 Molson. All rights reserved.
//

import Foundation
import SpriteKit
import Cocoa

class DealCard: SKSpriteNode {
    var myScene: GameScene
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init (scene:GameScene) {
        myScene = scene
        let texture = SKTexture(imageNamed: "CardBack")
        super.init(texture: texture, color: NSColor.clearColor(), size: CGSizeMake(myScene.width/11, myScene.width/8))
        self.position = CGPoint(x: myScene.width*13/14, y: myScene.width/14)
        self.userInteractionEnabled = true
    }

    
    override func mouseUp(theEvent: NSEvent) {
        for i in 0...9 {
            let card = myScene.deck.removeFirst()
            myScene.fieldCards[i].append(card)
            let numCards = myScene.fieldCards[i].count
            card.zPosition = CGFloat(numCards)
            card.position = CGPointMake(myScene.width/10*CGFloat(i)+myScene.width/20,myScene.height-myScene.width/15-CGFloat(25*(numCards-1)))
            myScene.addChild(card)
            myScene.cardsLeft.text = String(format:"%d",myScene.deck.count/10)
            anyDone(i)
        }
        if myScene.deck.count==0 {
            self.removeFromParent()
            myScene.cardsLeft.removeFromParent()
        }
    }
    
    func anyDone(i:Int) {
        let suit = myScene.fieldCards[i].last?.suit
        var value = 1
        for currCard in myScene.fieldCards[i].reverse() {
            if (currCard.value != value) || (currCard.suit != suit) || currCard.isFlipped {
                return
            } else if value==13 {
                for _ in 1...12 {
                    myScene.fieldCards[i].removeLast().removeFromParent()
                }
                let card = myScene.fieldCards[i].removeLast()
                card.zPosition = 35 + CGFloat(myScene.decksComplete)
                let action = SKAction.moveTo(CGPoint(x:150+30*CGFloat(myScene.decksComplete),y:150), duration: 0.5);
                card.runAction(action)
                myScene.decksComplete++
                if myScene.fieldCards[i].count>0 {
                    if ((myScene.fieldCards[i].last?.isFlipped) == true) {
                        myScene.fieldCards[i].last?.texture = SKTexture(imageNamed: String(format: "Cards/%@%d.png",(myScene.fieldCards[i].last?.suit)!,(myScene.fieldCards[i].last?.value)!))
                        myScene.fieldCards[i].last?.isFlipped = false
                    }
                }
            }
            value++
        }
    }
}