//
//  OverlayScrollView.swift
//  WWTouchDeme
//
//  Created by Brad G. on 6/20/16.
//  Copyright © 2016 Brad G. All rights reserved.
//

import UIKit

class OverlayScrollView: UIScrollView {

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, withEvent: event)
        if hitView === self {
            return nil
        }
        return hitView
    }

}
