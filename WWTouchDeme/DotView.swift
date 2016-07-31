//
//  DotView.swift
//  WWTouchDeme
//
//  Created by Brad G. on 6/20/16.
//  Copyright © 2016 Brad G. All rights reserved.
//

import UIKit

//MARK: - Random Int/Double
extension Int {
    static func random() -> Int {
        return Int(arc4random())
    }
    
    static func random(range: Range<Int>) -> Int {
        return Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex))) + range.startIndex
    }
}

extension Double {
    static func random() -> Double {
        return drand48()
    }
}

//MARK: - Random Color
extension UIColor{
    static func randomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
}

//MARK: - DotView
class DotView: UIView {
    //MARK: - Properties
    static let maxCirleDiameter = 120.0
    static let minCirleDiameter = 20.0
    let overlayLayer = CALayer()
    
    
    //MARK: - Class Functions
    static func randomDotView() -> DotView {
        let dotView = DotView()
        dotView.backgroundColor = UIColor.randomColor()
        let width = CGFloat(Int.random(Int(minCirleDiameter)...Int(maxCirleDiameter)))
        dotView.frame = CGRect(x: 0.0, y: 0.0, width: width, height: width)
        dotView.layer.cornerRadius = width * 0.5
        dotView.layer.masksToBounds = true
        return dotView
    }
    
    static func arrangeDotsRandomlyInView(view:UIView){
        let dots = view.subviews.filter{$0 is DotView}
        for dot in dots{
            let x = CGFloat(Int.random(Int(maxCirleDiameter * 0.5)...Int(view.bounds.width) - Int(maxCirleDiameter * 0.5)))
            let y = CGFloat(Int.random(Int(maxCirleDiameter * 0.5)...Int(view.bounds.height) - Int(maxCirleDiameter * 0.5)))
            dot.center = CGPoint(x: x, y: y)

        }
        
    }
    
    static func arrangeDotsNeatlyInView(view:UIView){
        let buffer:CGFloat = 5.0
        var xOffset:CGFloat = CGFloat(maxCirleDiameter * 0.5) + buffer
        var yOffset:CGFloat = CGFloat(maxCirleDiameter * 0.5) + buffer
        let dots = view.subviews.filter{$0 is DotView}

        for dot in dots
        {
            dot.center.x = xOffset
            dot.center.y = yOffset
            
            if dot.frame.maxX > view.frame.maxX
            {
                xOffset = CGFloat(maxCirleDiameter * 0.5) + buffer
                yOffset += CGFloat(maxCirleDiameter) + buffer
                
                dot.center.x = xOffset
                dot.center.y = yOffset
            }
            
            xOffset += CGFloat(maxCirleDiameter) + buffer
        }
        
    }
    
    static func arrangeDotsInViewWithNiftyAnimation(view:UIView){
        UIView.animateWithDuration(0.5, animations: {
            self.arrangeDotsNeatlyInView(view)
        })
    }
    
    //MARK: - Touch Handling
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.overlayLayer.backgroundColor = UIColor(white: 0.25, alpha: 0.5).CGColor
        self.overlayLayer.frame = self.bounds
        self.layer.addSublayer(self.overlayLayer)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.overlayLayer.removeFromSuperlayer()
    }

    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.overlayLayer.removeFromSuperlayer()
    }
    
    //MARK: - Hit Test
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        var touchBounds = self.bounds
        if self.bounds.width < 44.0
        {
            let expansion = (44.0 - self.bounds.width)/2.0
            touchBounds = CGRectInset(self.bounds, -expansion, -expansion)
        }
        return CGRectContainsPoint(touchBounds, point)
    }
}
