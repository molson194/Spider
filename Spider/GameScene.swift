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

var fieldCards:[[Card]] = [[Card]]()
var deck:[Card] = [Card]()

class GameScene: SKScene {
    var cardValue: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
    var cardSuit: [String] = ["Diamonds","Spades", "Hearts", "Clubs","Diamonds","Spades", "Hearts", "Clubs"]
    var newCards = SKSpriteNode.init()
    
    override func didMoveToView(view: SKView) {
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(myLabel)
        
        let texture = SKTexture(imageNamed: "CardBack")
        newCards = SKSpriteNode(texture: texture, color: NSColor.clearColor(), size: CGSize(width: 100,height: 150))
        newCards.position = CGPoint(x: 1200, y: 150)
        self.addChild(newCards)

        //TODO: if 1 deck-> cardSuit has spades...Keep adding cards until 8 sets
        let cardSet = NSImage(named: "CardSet")
        var x = 0
        var y = 0
        for mySuit in cardSuit {
            for myValue in cardValue {
                let cardImage = NSImage(size: CGSize(width: 100, height: 200))
                cardImage.lockFocus()
                cardSet?.drawInRect(NSRect(x: 0, y: 0, width: 100, height: 150), fromRect: NSRect(x: x*210, y: y*280, width: 179, height: 250), operation: NSCompositingOperation.CompositeCopy, fraction: 1)
                cardImage.unlockFocus()
                let newCard = Card(image: cardImage, suit: mySuit, value: myValue)
                deck.append(newCard)
                x++
                if x>12 {
                    x=0
                }
            }
            y++
            if y>3 {
                y=0
            }
        }
        deck = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(deck) as! [Card]
        var i = 0
        while i < 54 {
            let x = i%10
            let y = i/10
            let card = deck.first
            card?.zPosition = CGFloat(y)
            if i<10 {
                fieldCards.append([card!])
            } else {
                fieldCards[x].append(card!)
            }
            deck.removeFirst()
            card!.position = CGPointMake(CGFloat(125*x+80),CGFloat(700 - 35*y))
            self.addChild(card!)
            i++
        }
    }
    
    override func mouseUp(theEvent: NSEvent) {
        var i = 0
        while i < 10 {
            let card = deck.first
            let numCards = fieldCards[i].count
            card?.zPosition = CGFloat(numCards)
            fieldCards[i].append(card!)
            deck.removeFirst()
            card!.position = CGPointMake(CGFloat(125*i+80),CGFloat(700 - 35*numCards))
            self.addChild(card!)
            i++
        }
        if deck.count==0 {
            self.removeChildrenInArray([newCards])
        }
    }
    
    func getFieldCards() -> [[Card]] {
        return fieldCards
    }
    
    func setFieldCards(newFieldCards:[[Card]]) {
        fieldCards = newFieldCards
    }
}
