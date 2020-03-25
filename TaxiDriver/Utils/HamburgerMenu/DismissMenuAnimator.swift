//
//  DismissMenuAnimator.swift
//  OntarioCustomer
//
//  Created by Shivani Bajaj on 24/09/17.
//  Copyright © 2017 Shivani Bajaj. All rights reserved.
//

import UIKit

class DismissMenuAnimator: NSObject {

}

extension DismissMenuAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        
        //Get the snapshot made earlier
        let snapshot = containerView.viewWithTag(MenuHelper.Menu_SnapshotNo)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                // Bring the smapshot to full screen width
                snapshot?.frame = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)
        },
            completion: { _ in
                let didTransitionComplete = !transitionContext.transitionWasCancelled
                if didTransitionComplete {
                    // After inserting the toVC, remove the snapshot
                    containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
                    snapshot?.removeFromSuperview()
                }
                transitionContext.completeTransition(didTransitionComplete)
        }
        )
    }
}
