//
//  ViewController.swift
//  lab4
//
//  Created by Shawn Zhu on 9/16/15.
//  Copyright (c) 2015 Shawn Zhu. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var openPos: CGPoint!
    var closePos: CGPoint!
    
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
            println("Gesture began at: \(point)")
            trayOriginalCenter = trayView.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            var translation = sender.translationInView(view)
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == UIGestureRecognizerState.Ended {
            println("Gesture ended at: \(point)")
            if up {
                trayView.center = openPos
            } else {
                trayView.center = closePos
            }

        }

    }

}

