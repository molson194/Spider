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
        myScene.redoMoves = [Move]()
        var dealCards = [Card]()
        for i in 0...9 {
            let card = myScene.deck.removeFirst()
            dealCards.append(card)
            myScene.fieldCards[i].append(card)
            let numCards = myScene.fieldCards[i].count
            card.zPosition = CGFloat(numCards)
            card.position = CGPointMake(myScene.width/10*CGFloat(i)+myScene.width/20,myScene.height-myScene.width/15-CGFloat(25*(numCards-1)))
            myScene.addChild(card)
            myScene.cardsLeft.text = String(format:"%d",myScene.deck.count/10)
        }
        myScene.moves.append(Move(scene: myScene, type: "Deal", startPos: -1, endPos: -1, cards: dealCards))
        anyDone()
        if myScene.deck.count==0 {
            self.removeFromParent()
            myScene.cardsLeft.removeFromParent()
        }
    }
    
    func anyDone() {
        for i in 0...9 {
            let suit = myScene.fieldCards[i].last?.suit
            var value = 1
            for currCard in myScene.fieldCards[i].reverse() {
                if (currCard.value != value) || (currCard.suit != suit) || currCard.isFlipped {
                    break
                } else if value==13 {
                    var moveCards:[Card] = [Card]()
                    for _ in 1...12 {
                        let card = myScene.fieldCards[i].removeLast()
                        moveCards.append(card)
                        card.removeFromParent()
                    }
                    let card = myScene.fieldCards[i].removeLast()
                    moveCards.append(card)
                    myScene.cannotSelectKings.append(card)
                    card.zPosition = 35 + CGFloat(myScene.decksComplete)
                    let action = SKAction.moveTo(CGPoint(x:myScene.width/14+30*CGFloat(myScene.decksComplete),y:myScene.width/14), duration: 0.5);
                    card.runAction(action)
                    myScene.decksComplete++
                    myScene.moves.append(Move(scene: myScene, type: "King", startPos: i, endPos: -1, cards: moveCards))
                    if myScene.fieldCards[i].count>0 {
                        if ((myScene.fieldCards[i].last?.isFlipped) == true) {
                            myScene.fieldCards[i].last?.texture = SKTexture(imageNamed: String(format: "Cards/%@%d.png",(myScene.fieldCards[i].last?.suit)!,(myScene.fieldCards[i].last?.value)!))
                            myScene.fieldCards[i].last?.isFlipped = false
                            myScene.moves.last!.flipLast = true
                        }
                    }
                }
                value++
            }
        }
    }
}