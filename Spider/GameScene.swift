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
    var cardSuit: [String] = ["Spades","Spades", "Spades", "Spades","Spades","Spades", "Spades", "Spades"]
    var fieldCards:[[Card]] = [[Card]]()
    var deck:[Card] = [Card]()
    var decksComplete: Int = 0
    var moves:[Move] = [Move]()
    var redoMoves:[Move] = [Move]()
    
    //TODO resizing and moving card mouse location
    // TODO add animation http://stackoverflow.com/questions/27873931/swift-sprite-kit-how-do-you-set-an-animation-for-a-random-time
    // TODO new game menu popup with deck number selection
    // TODO stats
    // TODO replay game (random seed)
    // TODO undo newdeal and king
    
    override func didMoveToView(view: SKView) {
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Spider by Matt"
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

        for mySuit in cardSuit {
            for myValue in cardValue {
                let myImageName = String(format: "Cards/%@%d.png",mySuit,myValue)
                let newCard = Card(scene:self, imageName: myImageName, suit: mySuit, value: myValue)
                deck.append(newCard)
            }
        }
        deck = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(deck) as! [Card]

        for i in 0...53 {
            let x = i%10
            let y = i/10
            let card = deck.removeFirst()
            if i < 44 {
                card.texture = SKTexture(imageNamed: "CardBack")
                card.isFlipped = true
            }
            card.zPosition = CGFloat(y+1)
            if i<10 {
                fieldCards.append([card])
            } else {
                fieldCards[x].append(card)
            }
            card.position = CGPointMake(CGFloat(125*x+80),CGFloat(650-25*y))
            self.addChild(card)
        }
    }
    
    override func keyDown(theEvent: NSEvent) {
        print(theEvent.keyCode)
        if (theEvent.keyCode == 6) {
            if moves.count > 0 {
                moves.last!.undo()
                redoMoves.append(moves.removeLast())
            }
        } else if (theEvent.keyCode == 16){
            if redoMoves.count > 0 {
                redoMoves.last!.redo()
                moves.append(redoMoves.removeLast())
            }
        }
    }
}
