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
    var cardSuit: [String] = ["Clubs", "Diamonds", "Hearts", "Spades","Clubs", "Diamonds", "Hearts", "Spades"]
    
    override func didMoveToView(view: SKView) {
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
        //TODO: if 1 deck-> cardSuit has spades...
        //Keep adding cards until 8 sets
        for mySuit in cardSuit {
            for myValue in cardValue {
                let newCard = Card(imageName: "Logo-1.png", suit: mySuit, value: myValue)
                deck.append(newCard)
                //deck = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(deck) TODO
            }
        }
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
            card!.position = CGPointMake(CGFloat(125*x+80),CGFloat(650 - 35*y))
            self.addChild(card!)
            i++
        }
    }
    
    func getFieldCards() -> [[Card]] {
        return fieldCards
    }
    
    func setFieldCards(newFieldCards:[[Card]]) {
        fieldCards = newFieldCards
    }
}
