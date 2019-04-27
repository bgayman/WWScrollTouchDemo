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
    var drawerView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.canvasView.backgroundColor = UIColor.darkGray
        self.view.addSubview(self.canvasView)
        
        let touchDelay = TouchDelayGestureRecognizer(target: nil, action: nil)
        self.canvasView.addGestureRecognizer(touchDelay)
        
        self.addDots(count: 25, toView: self.canvasView)
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.drawerView)
        
        self.addDots(count: 20, toView: self.drawerView.contentView)
        self.view.addGestureRecognizer(self.scrollView.panGestureRecognizer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.canvasView.frame = self.view.bounds
        self.scrollView.frame = self.view.bounds
        self.drawerView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: 650.0)
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height + self.drawerView.bounds.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.contentOffset = CGPoint(x: CGFloat(0.0), y: self.drawerView.bounds.height)
        UIView.animate(withDuration: 0.5, animations: {
            DotView.arrangeDotsRandomlyInView(view: self.canvasView)
            DotView.arrangeDotsNeatlyInView(view: self.drawerView.contentView)
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Dots
    func addDots(count:Int, toView view:UIView){
        for _ in 0..<count{
            let dotView = DotView.randomDotView()
            view.addSubview(dotView)
            
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
            longPress.cancelsTouchesInView = false
            longPress.delegate = self
            dotView.addGestureRecognizer(longPress)
        }
    }
    
    func grabDot(dot:DotView, withGesture gesture:UILongPressGestureRecognizer)
    {
        dot.center = self.view.convert(dot.center, from: dot.superview)
        self.view.addSubview(dot)
        UIView.animate(withDuration: 0.2, animations: {
            dot.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            dot.alpha = 0.8
            self.moveDot(dot: dot, withGesture: gesture)
        })
        
        self.scrollView.panGestureRecognizer.isEnabled = false
        self.scrollView.panGestureRecognizer.isEnabled = true
        
        DotView.arrangeDotsInViewWithNiftyAnimation(view: self.drawerView.contentView)
    }
    
    func moveDot(dot:DotView, withGesture gesture:UILongPressGestureRecognizer)
    {
        dot.center = gesture.location(in: self.view)
    }
    
    func dropDot(dot:DotView, withGesture gesture:UILongPressGestureRecognizer)
    {
        UIView.animate(withDuration: 0.2, animations: {
            dot.transform = .identity
            dot.alpha = 1.0
        })
        
        let locationInDrawer = gesture.location(in: self.drawerView)
        
        if self.drawerView.bounds.contains(locationInDrawer){
            self.drawerView.contentView.addSubview(dot)
        }else{
            self.canvasView.addSubview(dot)
        }
        dot.center = self.view.convert(dot.center, to: dot.superview)
        
        DotView.arrangeDotsInViewWithNiftyAnimation(view: self.drawerView.contentView)
    }
    
    
    //MARK: - Gesture
    @objc func handleLongPress(_ sender:UILongPressGestureRecognizer){
        if let dot = sender.view as? DotView{
            switch sender.state {
            case .began:
                self.grabDot(dot: dot, withGesture:sender)
            case .changed:
                self.moveDot(dot: dot, withGesture:sender)
            case .ended:
                self.dropDot(dot: dot,withGesture:sender)
            case .cancelled:
                self.dropDot(dot: dot,withGesture:sender)
            default:
                break
            }
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}

