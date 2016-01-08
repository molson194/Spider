//
//  GameScene.swift
//  Spider
//
//  Created by Matthew Olson on 1/5/16.
//  Copyright (c) 2016 Molson. All rights reserved.
//

import SpriteKit
import Foundation
import GameplayKit

class GameScene: SKScene {
    var cardValue: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
    var cardSuit: [String] = ["Diamonds","Spades", "Hearts", "Clubs","Diamonds","Spades", "Hearts", "Clubs"]
    var fieldCards:[[Card]] = [[Card]]()
    var deck:[Card] = [Card]()
    
    override func didMoveToView(view: SKView) {
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(myLabel)
        
        let background = SKSpriteNode(imageNamed: "FeltBackground")
        background.position = CGPoint(x:0,y:0)
        background.anchorPoint = CGPoint(x:0.0,y:0.0)
        background.size = view.bounds.size
        background.zPosition = 0
        self.addChild(background)
        
        let dealCard = DealCard.init(scene: self)
        dealCard.zPosition = 1
        self.addChild(dealCard)

        //TODO: if 1 deck-> cardSuit has spades...Keep adding cards until 8 sets
        let cardSet = NSImage(named: "CardSet")
        var x = 0
        var y = 0
        for mySuit in cardSuit {
            for myValue in cardValue {
                let cardImage = NSImage(size: CGSize(width: 100, height: 200))
                cardImage.lockFocus()
                cardSet?.drawInRect(NSRect(x: 0, y: 0, width: 100, height: 150), fromRect: NSRect(x: x%13*210, y: y%4*280, width: 179, height: 250), operation: NSCompositingOperation.CompositeCopy, fraction: 1)
                cardImage.unlockFocus()
                let newCard = Card(scene:self, image: cardImage, suit: mySuit, value: myValue)
                deck.append(newCard)
                x++
            }
            y++
        }
        deck = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(deck) as! [Card]
        var i = 0
        while i < 54 {
            let x = i%10
            let y = i/10
            let card = deck.removeFirst()
            card.zPosition = CGFloat(y)
            if i<10 {
                fieldCards.append([card])
            } else {
                fieldCards[x].append(card)
            }
            card.position = CGPointMake(CGFloat(125*x+80),CGFloat(700 - 25*y))
            self.addChild(card)
            i++
        }
    }
}
