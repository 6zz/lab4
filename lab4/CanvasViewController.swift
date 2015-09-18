//
//  ViewController.swift
//  lab4
//
//  Created by Shawn Zhu on 9/16/15.
//  Copyright (c) 2015 Shawn Zhu. All rights reserved.
//

import UIKit

// reference to an associated-object
var newFaceOriginalCenter: CGPoint!

extension UIImageView {
    //
    // use associated-objects to add class variables to
    // already defined classes
    //
    class var originalCenter: CGPoint {
        get {
            return newFaceOriginalCenter
        }
        set (center) {
            newFaceOriginalCenter = center
        }
    }

    func doScaling(pinchGestureRecognizer: UIPinchGestureRecognizer) {
        NSLog("should scale")
        var scale = pinchGestureRecognizer.scale
        transform = CGAffineTransformMakeScale(scale, scale)
    }
    
    func onPan(panGestureRecognizer: UIPanGestureRecognizer) {
        switch panGestureRecognizer.state {
        case UIGestureRecognizerState.Began:
            var scale = CGFloat(2.0)
            transform = CGAffineTransformMakeScale(scale, scale)
            newFaceOriginalCenter = center
            
        case UIGestureRecognizerState.Changed:
            var translation = panGestureRecognizer.translationInView(superview!)
            center = CGPoint(
                x: UIImageView.originalCenter.x + translation.x,
                y: UIImageView.originalCenter.y + translation.y
            )
            
        case UIGestureRecognizerState.Ended:
            transform = CGAffineTransformIdentity
            
        default:
            NSLog("unhandled gesture recognizer state")
            
        }
    }
}

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var openPos: CGPoint!
    var closePos: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOrigin: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        openPos = trayView.center
        closePos = trayView.center
        closePos.y += 170.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTrayPanGesture(sender: UIPanGestureRecognizer) {
        var point = sender.locationInView(view)
        var velocity = sender.velocityInView(view)
        var up = (velocity.y < 0.0)
        
        if sender.state == UIGestureRecognizerState.Began {
            trayOriginalCenter = trayView.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            var translation = sender.translationInView(view)
            var newCenter = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
            if newCenter.y <= openPos.y {
                newCenter.y = trayOriginalCenter.y + translation.y / 10
            }
            trayView.center = newCenter
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 100.0, options: nil, animations: { () -> Void in
                if up {
                    self.trayView.center = self.openPos
                } else {
                    self.trayView.center = self.closePos
                }
            }, completion: nil)
        }

    }

    @IBAction func onFacePanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case UIGestureRecognizerState.Began:
            
            createNewFace(sender)
            
        case UIGestureRecognizerState.Changed:
            var translation = sender.translationInView(view)
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOrigin.x + translation.x, y: newlyCreatedFaceOrigin.y + translation.y)
            
//        case UIGestureRecognizerState.Ended:
//            
//            NSLog("ended")
        default:
            NSLog("unhandled")
            
        }
    }
    
    private func createNewFace(sender: UIPanGestureRecognizer) {
        var imageView = sender.view as! UIImageView
        
        newlyCreatedFace = UIImageView(image: imageView.image)
        addPinchGestureRecognizer(newlyCreatedFace)
        addPanGestureRecognizer(newlyCreatedFace)
        
        view.addSubview(newlyCreatedFace)
        newlyCreatedFace.center = imageView.center
        newlyCreatedFace.center.y += trayView.frame.origin.y
        newlyCreatedFaceOrigin = newlyCreatedFace.center
    }
    
    private func addPinchGestureRecognizer(target: UIImageView) {
        var gesture = UIPinchGestureRecognizer(target: target, action: "doScaling:")
        
        target.userInteractionEnabled = true
        target.addGestureRecognizer(gesture)
    }
    
    private func addPanGestureRecognizer(target: UIImageView) {
        var gesture = UIPanGestureRecognizer(target: target, action: "onPan:")
        
        target.userInteractionEnabled = true
        target.addGestureRecognizer(gesture)
    }

}

