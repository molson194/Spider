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
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        /* Pick a size for the scene */
        let scene = GameScene(size:self.skView.frame.size)
        scene.scaleMode = .AspectFill
        self.skView!.presentScene(scene)
            
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        self.skView!.ignoresSiblingOrder = true
        self.skView!.showsFPS = true
        self.skView!.showsNodeCount = true
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
    
}
