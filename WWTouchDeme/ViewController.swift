//
//  ViewController.swift
//  WWTouchDeme
//
//  Created by Brad G. on 6/20/16.
//  Copyright © 2016 Brad G. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    //MARK: - Properties
    
    var canvasView = UIView()
    var scrollView = OverlayScrollView()
    var drawerView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.canvasView.backgroundColor = UIColor.darkGrayColor()
        self.view.addSubview(self.canvasView)
        
        let touchDelay = TouchDelayGestureRecognizer(target: nil, action: nil)
        self.canvasView.addGestureRecognizer(touchDelay)
        
        self.addDots(25, toView: self.canvasView)
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.drawerView)
        
        self.addDots(20, toView: self.drawerView.contentView)
        self.view.addGestureRecognizer(self.scrollView.panGestureRecognizer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.canvasView.frame = self.view.bounds
        self.scrollView.frame = self.view.bounds
        self.drawerView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: 650.0)
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height + self.drawerView.bounds.height)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.contentOffset = CGPoint(x: CGFloat(0.0), y: self.drawerView.bounds.height)
        UIView.animateWithDuration(0.5, animations: {
            DotView.arrangeDotsRandomlyInView(self.canvasView)
            DotView.arrangeDotsNeatlyInView(self.drawerView.contentView)
        })
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    //MARK: - Dots
    func addDots(count:Int, toView view:UIView){
        for _ in 0..<count{
            let dotView = DotView.randomDotView()
            view.addSubview(dotView)
            
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_ :)))
            longPress.cancelsTouchesInView = false
            longPress.delegate = self
            dotView.addGestureRecognizer(longPress)
        }
    }
    
    func grabDot(dot:DotView, withGesture gesture:UILongPressGestureRecognizer)
    {
        dot.center = self.view.convertPoint(dot.center, fromView: dot.superview)
        self.view.addSubview(dot)
        UIView.animateWithDuration(0.2, animations: {
            dot.transform = CGAffineTransformMakeScale(1.2, 1.2)
            dot.alpha = 0.8
            self.moveDot(dot, withGesture: gesture)
        })
        
        self.scrollView.panGestureRecognizer.enabled = false
        self.scrollView.panGestureRecognizer.enabled = true
        
        DotView.arrangeDotsInViewWithNiftyAnimation(self.drawerView.contentView)
    }
    
    func moveDot(dot:DotView, withGesture gesture:UILongPressGestureRecognizer)
    {
        dot.center = gesture.locationInView(self.view)
    }
    
    func dropDot(dot:DotView, withGesture gesture:UILongPressGestureRecognizer)
    {
        UIView.animateWithDuration(0.2, animations: {
            dot.transform = CGAffineTransformIdentity
            dot.alpha = 1.0
        })
        
        let locationInDrawer = gesture.locationInView(self.drawerView)
        
        if CGRectContainsPoint(self.drawerView.bounds, locationInDrawer){
            self.drawerView.contentView.addSubview(dot)
        }else{
            self.canvasView.addSubview(dot)
        }
        dot.center = self.view.convertPoint(dot.center, toView: dot.superview)
        
        DotView.arrangeDotsInViewWithNiftyAnimation(self.drawerView.contentView)
    }
    
    
    //MARK: - Gesture
    @objc func handleLongPress(sender:UILongPressGestureRecognizer){
        if let dot = sender.view as? DotView{
            switch sender.state {
            case .Began:
                self.grabDot(dot, withGesture:sender)
            case .Changed:
                self.moveDot(dot, withGesture:sender)
            case .Ended:
                self.dropDot(dot,withGesture:sender)
            case .Cancelled:
                self.dropDot(dot,withGesture:sender)
            default:
                break
            }
        }
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}

