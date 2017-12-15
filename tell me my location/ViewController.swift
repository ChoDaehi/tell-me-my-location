//
//  ViewController.swift
//  tell me my location
//
//  Created by 조대희 on 2017. 12. 5..
//  Copyright © 2017년 AsiaQuest.inc. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
var distance = 0.0
var x0 = 0, y0 = 0

class ViewController: UIViewController,UIScrollViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var map: UIImageView!

    @IBOutlet weak var myView: UIView!
    
    var region: CLBeaconRegion!
    var locationManager: CLLocationManager!
    var uuids:[String]?
    weak var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.uuids = ["4FAEAACF-E336-4193-9ABE-F0821180EB69","78907890-7890-7890-7890-789078907890","EC5DD172-DD73-4985-A692-1715DC5DB426"]
    
    }
    override func viewDidAppear(_ animated: Bool) {
        ScrollView.contentSize = CGSize(width: 2000, height: 4000)
        ScrollView.delegate = self
        ScrollView.maximumZoomScale = 10
        ScrollView.minimumZoomScale = 1
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.ScrollView.contentSize = CGSize(width: self.ScrollView.zoomScale * 375, height: self.ScrollView.zoomScale*278)
        
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return map
    }
    func locationManager(_ locationManager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("許可承認")
        //    self.Status.text = "Starting Monitor"
            //デバイスに許可を促す
            locationManager.requestWhenInUseAuthorization()
          //  self.locationManager.startRangingBeacons(in: self.region)
         
            break
        case .authorizedAlways , .authorizedWhenInUse:
            //iBeaconによる領域観測を開始する
            print("観測開始")

            
            var i = 0
            while i < self.uuids!.count{
                let uuidString = self.uuids![i]
                let uuid = NSUUID.init(uuidString: uuidString)
                let beaconRegion = CLBeaconRegion.init(proximityUUID: uuid! as UUID, identifier: ("beaconRegion"+String(i)))
                
                self.locationManager.startMonitoring(for: beaconRegion)
                self.locationManager!.startRangingBeacons(in:beaconRegion)
                
                i += 1
            }
            i = 0
            break
            
            
     
            
        case .denied,.restricted:
            print("位置情報取得が拒否されました")
        
            break
            
        }
        
    }    //以下 CCLocationManagerデリゲートの実装---------------------------------------------->
    
    /*
     - (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
     Parameters
     manager : The location manager object reporting the event.
     region  : The region that is being monitored.
     */
    func locationManager(_ locationManager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        locationManager.requestState(for: region)
        
    }
    
    /*
     - (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
     Parameters
     manager :The location manager object reporting the event.
     state   :The state of the specified region. For a list of possible values, see the CLRegionState type.
     region  :The region whose state was determined.
     */
    func locationManager(_ locationManager: CLLocationManager, didDetermineState state: CLRegionState, for inRegion: CLRegion) {
        if (state == .inside) {
            //領域内にはいったときに距離測定を開始
            locationManager.startRangingBeacons(in: self.region)
        }
    }
    
    /*
     リージョン監視失敗（bluetoothの設定を切り替えたりフライトモードを入切すると失敗するので１秒ほどのdelayを入れて、再トライするなど処理を入れること）
     - (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
     Parameters
     manager : The location manager object reporting the event.
     region  : The region for which the error occurred.
     error   : An error object containing the error code that indicates why region monitoring failed.
     */
    private func locationManager(locationManager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        print("monitoringDidFailForRegion \(error)")

    }
    
    /*
     - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
     Parameters
     manager : The location manager object that was unable to retrieve the location.
     error   : The error object containing the reason the location or heading could not be retrieved.
     */
    //通信失敗
    func locationManager(locationManager: CLLocationManager!, didFailWithError error: Error!,_: Error!) {
        print("didFailWithError \(error)")
    }
    
    func locationManager(_ locationManager: CLLocationManager, didEnterRegion region: CLRegion) {
        locationManager.startRangingBeacons(in: region as! CLBeaconRegion)
 //       self.Status.text = "Possible Match"
    }
    
    func locationManager(_ locationManager : CLLocationManager, didExitRegion region: CLRegion) {
        locationManager.stopRangingBeacons(in: region as! CLBeaconRegion)
        reset()
    }
    
    /*
     beaconsを受信するデリゲートメソッド。複数あった場合はbeaconsに入る
     - (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
     Parameters
     manager : The location manager object reporting the event.
     beacons : An array of CLBeacon objects representing the beacons currently in range. You can use the information in these objects to determine the range of each beacon and its identifying information.
     region  : The region object containing the parameters that were used to locate the beacons
     */
    func locationManager(_ locationManager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(beacons)
        var j = 0
        if(beacons.count == 0) { return }
        else {
            
            while j < beacons.count {
                
                let beacon = beacons[j]
                
                let screenWidth = self.map.bounds.width
                let screenHeight = self.map.bounds.height
                distance = Double((10^(-70-beacon.rssi))^(1/20))
                let circles = Circles(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
              //  circles.removeFromSuperview()

                switch beacon.major {
                case 312 : //ビーコンに貼ってあるシール　4
                    x0 = 15; y0 = 250
                case 59275 : //ビーコンに貼ってあるシール　24
                    x0 = 30; y0 = 195
                case 9999: //ビーコンに貼ってあるシール　30
                    x0 = 110; y0 = 195
                case 9998:
                    x0 = 55; y0 = 220
                default:
                    break
                }
            
                if beacon.rssi != 0 && beacon.rssi >= -90
                { self.map.addSubview(circles) }
                
                
                circles.isOpaque = false
                self.view.backgroundColor = UIColor(red:0.0,green:0.0,blue:1.0,alpha:1.0)

                /*
                 beaconから取得できるデータ
                 proximityUUID   :   regionの識別子
                 major           :   識別子１
                 minor           :   識別子２
                 rssi            :   電波強度
                 */
                //  if beacon.rssi > -40  {

                // }
                //  else {
                //  reset()
                //  }
                
                if j == beacons.count -  1 {j = 0; break}
                                j += 1
            }
        }
    }
    func reset(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

    
    




