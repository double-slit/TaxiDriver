//
//  PresentMenuAnimator.swift
//  OntarioCustomer
//
//  Created by Shivani Bajaj on 24/09/17.
//  Copyright © 2017 Shivani Bajaj. All rights reserved.
//

import UIKit

class PresentMenuAnimator: NSObject {

}

extension PresentMenuAnimator:UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        //Capturing the snapshot
        
        if let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false) {
            snapshot.tag = MenuHelper.Menu_SnapshotNo
            snapshot.isUserInteractionEnabled = false
            snapshot.layer.shadowOpacity = 0.5
            containerView.insertSubview(snapshot, aboveSubview: toVC.view)
            fromVC.view.isHidden = true
            
    
            //Perform the actual animation
            
            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                animations: {
                    snapshot.center.x += UIScreen.main.bounds.width * MenuHelper.Menu_Width
            },
                completion: { _ in
                    fromVC.view.isHidden = false
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            )
        }
        
    }
}
