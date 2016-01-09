//
//  NewGameViewController.swift
//  Spider
//
//  Created by Matthew Olson on 1/8/16.
//  Copyright © 2016 Molson. All rights reserved.
//

import Cocoa
import SpriteKit

class NewGameViewController: NSViewController {
    
    @IBOutlet var control:NSSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let numSuits = defaults.integerForKey("NumSuits")
        if numSuits == 1 {
            control.selectedSegment = 0
        } else if numSuits == 4 {
            control.selectedSegment = 2
        } else {
            control.selectedSegment = 1
        }
    }
    @IBAction func decodeButton(segmentedControl:NSSegmentedControl){
        let defaults = NSUserDefaults.standardUserDefaults()
        if (segmentedControl.selectedSegment == 0) {
            defaults.setValue(1, forKey: "NumSuits")
        } else if(segmentedControl.selectedSegment == 1) {
            defaults.setValue(2, forKey: "NumSuits")
        } else if(segmentedControl.selectedSegment == 2) {
            defaults.setValue(4, forKey: "NumSuits")

        }
        defaults.synchronize()
    }
}
