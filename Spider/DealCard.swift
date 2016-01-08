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
        super.init(texture: texture, color: NSColor.clearColor(), size: CGSizeMake(100, 150))
        self.position = CGPoint(x: 1200, y: 150)
        self.userInteractionEnabled = true
    }

    
    override func mouseUp(theEvent: NSEvent) {
        var i = 0
        var myDeck = myScene.deck
        var myFieldCards = myScene.fieldCards
        while i < 10 {
            let card = myDeck.removeFirst()
            myFieldCards[i].append(card)
            let numCards = myFieldCards[i].count
            card.zPosition = CGFloat(numCards)
            card.position = CGPointMake(CGFloat(125*i+80),CGFloat(700 - 25*numCards))
            myScene.addChild(card)
            if isDone(i) {
                for _ in 1...12 {
                    //increment number of decks done, move the king to corner, if number of decks done is 8 game over
                    let card = myFieldCards[i].removeLast()
                    card.removeFromParent()
                }
                //TODO move king
            }
            i++
        } // TODO add animation http://stackoverflow.com/questions/27873931/swift-sprite-kit-how-do-you-set-an-animation-for-a-random-time
        if myDeck.count==0 {
            self.removeFromParent()
        }
        myScene.fieldCards = myFieldCards
        myScene.deck = myDeck
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
}