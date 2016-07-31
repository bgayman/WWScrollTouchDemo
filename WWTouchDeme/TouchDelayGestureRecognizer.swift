//
//  TouchDelayGestureRecognizer.swift
//  WWTouchDeme
//
//  Created by Brad G. on 6/20/16.
//  Copyright © 2016 Brad G. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class TouchDelayGestureRecognizer: UIGestureRecognizer {
    //MARK: - Property
    var timer:NSTimer?
    
    //MARK: - Init
    override init(target: AnyObject?, action: Selector) {
        super.init(target: target, action: action)
        self.delaysTouchesBegan = true
    }

    //MARK: - Touch Handling
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        self.timer = NSTimer(timeInterval: 0.15, target: self, selector: #selector(self.fail), userInfo: nil, repeats: false)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        self.fail()
    }
    
    override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
        self.fail()
    }
    
    //MARK: - Fail/Reset
    @objc func fail(){
        self.state = .Failed
    }
    
    override func reset() {
        self.timer?.invalidate()
        self.timer = nil
    }
}
