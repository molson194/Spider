//
//  AppDelegate.swift
//  Spider
//
//  Created by Matthew Olson on 1/5/16.
//  Copyright (c) 2016 Molson. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    let popover = NSPopover()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        /* Pick a size for the scene */
        let defaults = NSUserDefaults.standardUserDefaults()
        let height = defaults.integerForKey("Height")
        let width = defaults.integerForKey("Width")
        let scene:GameScene
        if(height == 0 || width == 0) {
            scene = GameScene(size:self.skView.frame.size)
        } else {
            scene = GameScene(size:CGSize(width: width, height: height))
            window.setContentSize(CGSize(width: width, height: height))
        }
        
        
        let numSuits = defaults.integerForKey("NumSuits")
        scene.scaleMode = .Fill
        scene.numDecks(numSuits)
        self.skView!.presentScene(scene)
            
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        self.skView!.ignoresSiblingOrder = true
        self.skView!.showsFPS = true
        self.skView!.showsNodeCount = true
    }
    
    func applicationWillTerminate(notification: NSNotification) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(self.skView.frame.size.height, forKey: "Height")
        defaults.setValue(self.skView.frame.size.width, forKey: "Width")
        defaults.synchronize()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func undoMove(id: NSMenuItem) {
        let myScene = self.skView.scene as! GameScene
        myScene.undoPressed()
    }
    
    @IBAction func redoMove(id: NSMenuItem) {
        let myScene = self.skView.scene as! GameScene
        myScene.redoPressed()
    }
    
    @IBAction func newGame(id: NSMenuItem) {
        let newGameController = NewGameViewController()
        popover.contentViewController = newGameController
        let positioningRect = NSRect(x: CGRectGetMidX(window.frame)-130, y: CGRectGetHeight(window.frame)-30, width: 100, height: 100)
        popover.showRelativeToRect(positioningRect, ofView: self.skView, preferredEdge: NSRectEdge.MinY)
    }
    
    @IBAction func playGame(sender:NSButton) {
        popover.close()
        let defaults = NSUserDefaults.standardUserDefaults()
        let numSuits = defaults.integerForKey("NumSuits")
        let scene = GameScene(size:self.skView.frame.size)
        scene.scaleMode = .AspectFill
        scene.numDecks(numSuits)
        self.skView!.presentScene(scene)
    }
    
    @IBAction func cancelPopover(sender:NSButton) {
        popover.close()
    }
}
