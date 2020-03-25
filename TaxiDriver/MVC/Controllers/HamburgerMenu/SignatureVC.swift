//
//  SignatureVC.swift
//  FastboxDriver
//
//  Created by Apple on 31/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class SignatureVC: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var imgView_Signature: UIImageView!
    @IBOutlet weak var imgView_Sign: UIImageView!
    
    //MARK:- Variables
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var isContinousStroke = false
    
    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Setup Methods
    
    func draw_Line(fromPoint:CGPoint,toPoint:CGPoint) {
        UIGraphicsBeginImageContext(imgView_Signature.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            imgView_Sign.isHidden = true
            imgView_Signature.image?.draw(in: imgView_Signature.bounds)
            context.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
            context.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
            
            context.setLineCap(.round)
            context.setLineWidth(10)
            context.setStrokeColor(red: 235/255, green: 58/255, blue: 63/255, alpha: 1)
            context.setBlendMode(.normal)
            context.strokePath()
            
            imgView_Signature.image = UIGraphicsGetImageFromCurrentImageContext()
            imgView_Signature.alpha = 1.0
            UIGraphicsEndImageContext()
        }
    }
    
    //MARK:- Touch Notifying Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        imgView_Signature.image = nil
        isContinousStroke = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
            draw_Line(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        isContinousStroke = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            draw_Line(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if !isContinousStroke {
//            draw_Line(fromPoint: lastPoint, toPoint: lastPoint)
//        }
    }
    
    //MARK:- Button Actions
    
    
    @IBAction func Action_Back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_Continue(_ sender: UIButton) {
        for controller in self.navigationController!.viewControllers {
            if controller.isKind(of: HomeScreenVC.classForCoder()) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
}
