//
//  StageViewController.swift
//  ab
//
//  Created by 大川理人 on 2016/06/05.
//  Copyright © 2016年 大川理人. All rights reserved.
//

import UIKit
import SpriteKit

class StageViewController: UIViewController {
    @IBOutlet var gameView: SKView!
    
    var gameScene : GameScene!
    
    var newdistance : Int!
    var newspeed : Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let scene = GameScene(fileNamed:"GameScene"){
            gameScene = scene
            gameView.showsFPS = true
            gameView.showsNodeCount = true
            gameView.ignoresSiblingOrder = true
            gameScene.scaleMode = .AspectFill
            gameScene.frame.offsetBy(dx: gameView.frame.width/2 , dy: gameView.frame.height/2)
            gameView.presentScene(gameScene)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func jump (){
        gameScene.jumpingAction()
    }
    @IBAction func pausebutton () {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
