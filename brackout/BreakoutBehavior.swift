//
//  BreakoutBehavior.swift
//  brackout
//
//  Created by Daniil Pimenau on 08-06-16.
//  Copyright © 2016 Daniil Pimenau. All rights reserved.
//

import UIKit

// MARK: - PROTOCOL

protocol BreakoutCollisionBehaviorDelegate: class {
    func ballHitBrick(behavior: UICollisionBehavior, ball: BallView, brickIndex: Int)
    func ballLeftPlayingField(ball: BallView)
}

private struct Constants {
    struct Ball {
        static let MinVelocity = CGFloat(100.0)
        static let MaxVelocity = CGFloat(1400.0)
    }
}

// MARK: - CLASS BreakoutBehavior

class BreakoutBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate {
    weak var breakoutCollisionDelegate: BreakoutCollisionBehaviorDelegate?
    
    let gravity = UIGravityBehavior()
    
    var collisionDelegate: UICollisionBehaviorDelegate? {
        didSet { collider.collisionDelegate = collisionDelegate}
    }
    
    // MARK: - COLLIDER
    
    private lazy var collider: UICollisionBehavior = {
        let lazyCollider = UICollisionBehavior()
        lazyCollider.translatesReferenceBoundsIntoBoundary = false
        lazyCollider.collisionDelegate = self
        lazyCollider.action = { [unowned self] in
            
            for ball in self.balls {
                if !CGRectIntersectsRect(self.dynamicAnimator!.referenceView!.bounds, ball.frame){
                    self.breakoutCollisionDelegate?.ballLeftPlayingField( ball as BallView)
                }
                
                self.ballBehavior.limitLinearVelocity(Constants.Ball.MinVelocity,
                                                      max: Constants.Ball.MaxVelocity,
                                                      forItem: ball as BallView)
            }
        }
        return lazyCollider
    }()
    
    // MARK: - ballBehavior
    
    lazy var ballBehavior: UIDynamicItemBehavior = {
        let lazyBallBehavior = UIDynamicItemBehavior()
        lazyBallBehavior.allowsRotation = false
        lazyBallBehavior.elasticity = 1.0
        lazyBallBehavior.friction = 0.0
        lazyBallBehavior.resistance = 0.0
        return lazyBallBehavior
    }()
    
    var gravityOn: Bool!
    
    var balls: [BallView] {
        get { return collider.items.filter{$0 is BallView}.map{$0 as! BallView} }
    }
    
    // MARK: - INIT
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(ballBehavior)
    }
    
    // MARK: - BOUNDARIES
    
    func addBoundary(path: UIBezierPath, named identifier: NSCopying) {
        removeBoundary(identifier)
        collider.addBoundaryWithIdentifier(identifier, forPath: path)
    }
    
    func removeBoundary (identifier: NSCopying) {
        collider.removeBoundaryWithIdentifier(identifier)
    }
    
    // MARK: - COLLISION BEHAVIOR
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem,
                           withBoundaryIdentifier boundaryId: NSCopying?,
                                                  atPoint p: CGPoint) {
        if let brickIndex = boundaryId as? Int {
            if let ball = item as? BallView {
                self.breakoutCollisionDelegate?.ballHitBrick(behavior, ball: ball,
                                                             brickIndex: brickIndex)
            }
        }
    }
    // MARK: - BALL
    
    func addBall(ball: UIView) {
        
        self.dynamicAnimator?.referenceView?.addSubview(ball)
        //  if gravityOn == true { gravity.addItem(ball) }
        collider.addItem(ball)
        ballBehavior.addItem(ball)
    }
    
    func removeBall(ball: UIView) {
        gravity.removeItem(ball)
        collider.removeItem(ball)
        ballBehavior.removeItem(ball)
        ball.removeFromSuperview()
    }
    
    func removeAllBalls(){
        for ball in balls {
            ballBehavior.removeItem(ball)
            collider.removeItem(ball)
            gravity.removeItem(ball)
            ball.removeFromSuperview()
        }
    }
    
    // MARK: -  stop de bal
    func stopBall(ball: UIView) -> CGPoint {
        let linVeloc = ballBehavior.linearVelocityForItem(ball)
        ballBehavior.addLinearVelocity(CGPoint(x: -linVeloc.x, y: -linVeloc.y), forItem: ball)
        return linVeloc
    }
    
    // MARK: -  start de bal na stoppen
    func startBall(ball: UIView, velocity: CGPoint) {
        ballBehavior.addLinearVelocity(velocity, forItem: ball)
    }
    
    // MARK: - push de ball
    func launchBall(ball: UIView, magnitude: CGFloat, minAngle: Int = 0, maxAngle: Int = 360) {
        let pushBehavior = UIPushBehavior(items: [ball], mode: .Instantaneous)
        pushBehavior.magnitude = magnitude
        
        let randomAngle = minAngle + Int( arc4random_uniform( UInt32(maxAngle - minAngle + 1) ) )
        let randomAngleRadian = Double(randomAngle) * M_PI / 180.0
        pushBehavior.angle = CGFloat(randomAngleRadian)
        
        pushBehavior.action = { [weak pushBehavior] in
            if !pushBehavior!.active { self.removeChildBehavior(pushBehavior!) }
        }
        
        addChildBehavior(pushBehavior)
    }
    
    func linearVelocityBall (item: UIDynamicItem) -> CGPoint {
        return ballBehavior.linearVelocityForItem(item)}
}
// MARK: - LINEAR VELOCITY


private extension UIDynamicItemBehavior {
    
    func limitLinearVelocity(min: CGFloat, max: CGFloat, forItem item: UIDynamicItem) {
        assert(min < max, "min < max")
        let itemVelocity = linearVelocityForItem(item)
        (item as! BallView).backgroundColor = UIColor.whiteColor()
        switch itemVelocity.magnitude {
        case  let x where x < CGFloat(700.0) :
            (item as! BallView).backgroundColor = UIColor.yellowColor()
        case  let x where x < 900 && x >= 700 :
            (item as! BallView).backgroundColor = UIColor.orangeColor()
        case  let x where x  < 1100 && x >= 900 :
            (item as! BallView).backgroundColor = UIColor.redColor()
        case  let x where  x >= 1100 :
            (item as! BallView).backgroundColor = UIColor.magentaColor()
        default:
            (item as! BallView).backgroundColor = UIColor.whiteColor()
        }
        if itemVelocity.magnitude <= 0.0 { return }
        if itemVelocity.magnitude < min {
            let deltaVelocity = min/itemVelocity.magnitude * itemVelocity - itemVelocity
            //                println ("magnitude = \(itemVelocity.magnitude) delta = \(deltaVelocity)")
            addLinearVelocity(deltaVelocity, forItem: item)
        }
        if itemVelocity.magnitude > max  {
            //            println(itemVelocity.magnitude )
            (item as! BallView).backgroundColor = UIColor.redColor()
            let deltaVelocity = max/itemVelocity.magnitude * itemVelocity - itemVelocity
            addLinearVelocity(deltaVelocity, forItem: item)
        }
    }
}

private extension CGPoint {
    var angle: CGFloat {
        get { return CGFloat(atan2(self.x, self.y)) }
    }
    var magnitude: CGFloat {
        get { return CGFloat(sqrt(self.x*self.x + self.y*self.y)) }
    }
}
prefix func -(left: CGPoint) -> CGPoint {
    return CGPoint(x: -left.x, y: -left.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x-right.x, y: left.y-right.y)
}

func *(left: CGFloat, right: CGPoint) -> CGPoint {
    return CGPoint(x: left*right.x, y: left*right.y)
}

