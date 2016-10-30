//
//  GameScene.swift
//  ab
//
//  Created by 大川理人 on 2016/10/02.
//  Copyright © 2016年 大川理人. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let baseNode = SKNode()
    let backScrNode = SKNode()
    var allScreenSize = CGSizeMake(0,0)
    let oneScreenSize = CGSizeMake(667,375)
    
    var playerNode: SKSpriteNode!
    var playerDirection: Direction = .Right
    var physicsRadius: CGFloat = 14.0
    var playerAcceleration: CGFloat = 30.0
    var playerMaxVelocity: CGFloat = 100.0
    var jumpForce: CGFloat = 20.0
    var charXOFFset: CGFloat = 0
    var charYOFFset: CGFloat = 0
    var moving: Bool = false
    var jumping: Bool = false
    var falling: Bool = false
    var tapPoint: CGPoint = CGPointZero
//    var screenSpeed: CGFloat = 12.0
//    var screenSpeedScale: CGFloat = 1.0
    
    
    enum Direction: Int {
        case Right    = 0
        case Left     = 1
    }
    enum NodeName: String {
        case frame_ground = "frame_ground"
        case frame_floor = "frame_floor"
        case player = "player"
        case backGround = "backGround"
        case ground = "ground"
        case floor = "floor"
        
        func category()->UInt32{
            switch self {
            case.frame_ground:
                return 0x00000001 << 0
            case.frame_floor:
                return 0x00000001 << 1
            case.player:
                return 0x00000001 << 2
            default:
                return 0x00000000
            }
        }
    }
    override func didMoveToView(view: SKView) {
        //physicsWorld.gravity.dy = -9.8
        self.backgroundColor = SKColor.clearColor()
        self.physicsWorld.contactDelegate = self
        self.addChild(self.baseNode)
        self.addChild(self.backScrNode)
        let wCount = 4
        self.allScreenSize = CGSizeMake(self.oneScreenSize.width * CGFloat(wCount), self.size.height)
        
//        self.enumerateChildNodesWithName("back_wall", usingBlock: { (node, stop) -> Void in
//            let back_wall = node as! SKSpriteNode
//            back_wall.name = NodeName.backGround.rawValue
//            back_wall.removeFromParent()
//            self.backScrNode.addChild(back_wall) })
        self.enumerateChildNodesWithName("ground", usingBlock: { (node, stop) -> Void in
            let ground = node as! SKSpriteNode
            ground.name = NodeName.ground.rawValue
            ground.removeFromParent()
            self.baseNode.addChild(ground) })
        self.enumerateChildNodesWithName("floor", usingBlock: { (node, stop) -> Void in
            let floor = node as! SKSpriteNode
            floor.name = NodeName.floor.rawValue
            floor.removeFromParent()
            self.baseNode.addChild(floor)
        })

        self.playerDirection = .Right
        self.charXOFFset = self.oneScreenSize.width * 0.5
        self.charYOFFset = self.oneScreenSize.height * 0.5
        self.enumerateChildNodesWithName("player", usingBlock: { (node, stop) -> Void in
            let player = node as! SKSpriteNode
            self.playerNode = player
            player.removeFromParent()
            self.baseNode.addChild(self.playerNode)
            self.playerNode.physicsBody = SKPhysicsBody(circleOfRadius: self.physicsRadius,center: CGPointMake(0, self.physicsRadius))
            self.playerNode.physicsBody!.friction = 1.0
            self.playerNode.physicsBody!.allowsRotation = false
            self.playerNode.physicsBody!.restitution = 0.0
            self.playerNode.physicsBody!.categoryBitMask = NodeName.player.category()
            self.playerNode.physicsBody!.collisionBitMask = NodeName.frame_ground.category()|NodeName.frame_floor.category()
            self.playerNode.physicsBody!.contactTestBitMask = 0
            self.playerNode.physicsBody!.usesPreciseCollisionDetection = true })
            let wallFrameNode = SKNode()
            self.baseNode.addChild(wallFrameNode)
            wallFrameNode.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, 0, self.size.width, self.size.height))
            wallFrameNode.physicsBody!.categoryBitMask = NodeName.frame_ground.category()
            wallFrameNode.physicsBody!.usesPreciseCollisionDetection = true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var location: CGPoint!
        for touch in touches {
            location = touch.locationInNode(self)
        }
        self.tapPoint = location
        self.playerNode.physicsBody!.linearDamping = 0.0
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var location: CGPoint!
        for touch in touches {
            location = touch.locationInNode(self)
    }
    let radian = (atan2(location.y-self.tapPoint.y, location.x-self.tapPoint.x))
    let angle = radian * 180 / CGFloat(M_PI)
        if angle > -90 && angle < 90 { if self.moving == false || self.playerDirection != .Right { self.moveToRight()
        }
    }
    else { if self.moving == false || self.playerDirection != .Left{
            self.moveToLeft()
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.moveStop()
    }
    func moveToRight() {
        self.moving = true
        
        self.playerDirection = .Right
        if self.jumping == false && self.falling == false {
            let names = ["right2", "right1","right3","right1"]
            self.startTextureAnimation(self.playerNode, names: names)
        } else {
            self.playerNode.texture = SKTexture(imageNamed: "right_jumping1")
        }
    }
    func moveToLeft() {
        self.moving = true
        
        self.playerDirection = .Left
        if self.jumping == false && self.falling == false {
            let names = ["left2", "left1","left3","left1"]
            self.startTextureAnimation(self.playerNode, names: names)
        } else {
            self.playerNode.texture = SKTexture(imageNamed: "left_jumping1")
        }
    }
     func moveStop() {
        self.moving = false
        
        if self.jumping == false && self.falling == false {
            var name: String!
            if self.playerDirection == .Right {
                name = "right1"
            } else {
                name = "left1" }
            self.stopTextureAnimation(self.playerNode, name: name)
            self.playerNode.physicsBody!.velocity = CGVectorMake(0, 0)
        }
    }
    func startTextureAnimation(node: SKSpriteNode, names: [String]) {
        node.removeActionForKey("textureAnimation")
        var ary: [SKTexture] = []
        for name in names {
            ary.append(SKTexture(imageNamed: name))
        }
        let action = SKAction.animateWithTextures(ary, timePerFrame: 0.1, resize: false, restore: false)
        node.runAction(SKAction.repeatActionForever(action), withKey: "textureAnimation")
    }
    func stopTextureAnimation(node: SKSpriteNode, name: String) {
        node.removeActionForKey("textureAnimation")
        node.texture = SKTexture(imageNamed: name)
    }
    override func update(currentTime: CFTimeInterval) {
        
        if self.moving == true {
            var dx: CGFloat = 0
            var dy: CGFloat = 0
            if self.playerDirection == .Right {
                dx = self.playerAcceleration
                dy = 0.0
            }else if self.playerDirection == .Left {
                dx = -(self.playerAcceleration)
                dy = 0.0
            }
            self.playerNode.physicsBody!.applyImpulse(CGVectorMake(dx, dy))
            
            if self.jumping == false && self.falling == false {
                 if self.playerNode.physicsBody!.velocity.dx > self.playerMaxVelocity {
                    self.playerNode.physicsBody!.velocity.dx = self.playerMaxVelocity
                 }
                 else if self.playerNode.physicsBody!.velocity.dx < -(self.playerMaxVelocity) {
                    self.playerNode.physicsBody!.velocity.dx = -(self.playerMaxVelocity) }
            } else {
             if self.playerNode.physicsBody!.velocity.dx > self.playerMaxVelocity / 2 {
                self.playerNode.physicsBody!.velocity.dx = self.playerMaxVelocity / 2
             }
             else if self.playerNode.physicsBody!.velocity.dx < -(self.playerMaxVelocity / 2) {
                self.playerNode.physicsBody!.velocity.dx = -(self.playerMaxVelocity / 2)
                }
            }
        }
        if self.playerNode.physicsBody?.velocity.dy < -9.8 && self.falling == false{
            self.jumping = false
            self.falling = true
            
            self.playerNode.physicsBody!.collisionBitMask = NodeName.frame_ground.category()|NodeName.frame_floor.category()
            self.playerNode.physicsBody!.contactTestBitMask = NodeName.frame_floor.category()|NodeName.frame_ground.category()
            if self.playerDirection == .Left {
                self.stopTextureAnimation(self.playerNode, name: "left_falling1")
            }
            else {
                self.stopTextureAnimation(self.playerNode, name: "right_falling1")
            }
        }
    }
    func jumpingAction(){
        if self.jumping == false && self.falling == false {
            self.moving = false
            self.jumping = true
            
            self.playerNode.physicsBody!.collisionBitMask = NodeName.frame_ground.category()
            self.playerNode.physicsBody!.contactTestBitMask = 0
            
            if self.playerDirection == .Left{
                self.stopTextureAnimation(self.playerNode, name: "left_jumping1")
                self.playerNode.physicsBody!.applyImpulse(CGVectorMake(0.0,self.jumpForce))
            }
            else {
                self.stopTextureAnimation(self.playerNode, name: "right_jumping1")
                self.playerNode.physicsBody!.applyImpulse(CGVectorMake(0.0, self.jumpForce))
            }
        }
    }
    func didBeginContact(contact: SKPhysicsContact) {
        self.playerNode.physicsBody!.collisionBitMask = NodeName.frame_ground.category()|NodeName.frame_floor.category()
        self.playerNode.physicsBody!.contactTestBitMask = 0
        
        self.jumping = false
        self.falling = false
        
        if self.moving {
            if self.playerDirection == .Right {
                self.moveToRight()
            }else if self.playerDirection == .Left {
                self.moveToLeft()
            }
        }
        else{
            self.moveStop()
        }
    }
}