//
//  ViewController.swift
//  ab
//
//  Created by 大川理人 on 2016/06/05.
//  Copyright © 2016年 大川理人. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //位置情報の取得に使う変数
    var myLocationManager:CLLocationManager!
    var nowlatitude: Float!
    var nowlongitude: Float!
    var location1: CLLocation!
    var location2: CLLocation!
    var distance: Double!
    var newdistance: Int!
    var startDate: NSDate!
    var stopDate: NSDate!
    var totalDate: Double!
    var speed: Double!
    var newspeed: Int!
    @IBOutlet var label: UILabel!
    @IBOutlet var label2: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //現在地の取得
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.distanceFilter = 100
        myLocationManager.requestAlwaysAuthorization()
        myLocationManager.startUpdatingLocation()
        
        if(CLLocationManager.locationServicesEnabled()) {
            print(CLLocationManager.locationServicesEnabled())
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startgame" {
            let stageViewController = segue.destinationViewController as! StageViewController
            
            stageViewController.newdistance = self.newdistance
            stageViewController.newspeed = self.newspeed
        }
    }
    //計測を始める
    @IBAction func onClicstartButton(sender: UIButton){
        myLocationManager.startUpdatingLocation()
        location1 = CLLocation(latitude: Double(nowlatitude), longitude: Double(nowlongitude))
        startDate = NSDate()
    }
    //計測をやめる
    @IBAction func onClicstopButton(sender: UIButton){
        myLocationManager.startUpdatingLocation()
        location2 = CLLocation(latitude: Double(nowlatitude), longitude: Double(nowlongitude))
        distance = location2.distanceFromLocation(location1)
        label.text = String(Int(distance))
        stopDate = NSDate()
        totalDate = stopDate.timeIntervalSinceDate(startDate)
        speed = distance / totalDate
        label2.text = String(Int(speed))
    }
    //位置情報の取得の成功時
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("緯度：\(manager.location!.coordinate.latitude)")
        print("経度：\(manager.location!.coordinate.longitude)")
        nowlatitude = Float(manager.location!.coordinate.latitude)
        nowlongitude = Float(manager.location!.coordinate.longitude)
    }
    //位置譲歩取得の失敗時
    func locationManager(manager: CLLocationManager,didFailWithError error: NSError){
        print("error")
    }
}

