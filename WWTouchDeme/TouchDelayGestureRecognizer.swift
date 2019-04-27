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
    var timer:Timer?
    
    //MARK: - Init
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        self.delaysTouchesBegan = true
    }

    //MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        timer = Timer(timeInterval: 0.15, target: self, selector: #selector(self.fail), userInfo: nil, repeats: false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        fail()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        fail()
    }
    
    //MARK: - Fail/Reset
    @objc func fail(){
        self.state = .failed
    }
    
    override func reset() {
        self.timer?.invalidate()
        self.timer = nil
    }
}
