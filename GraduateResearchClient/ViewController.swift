//
//  ViewController.swift
//  GraduateResearchClient
//
//  Created by 丸山拓己 on 2018/09/15.
//  Copyright © 2018年 丸山拓己. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    var locationManager: CLLocationManager!
    let request: Request = Request()
    var timer: Timer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(ViewController.timerUpdate), userInfo: nil, repeats: true)
        locationManager = CLLocationManager() // インスタンスの生成
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self // CLLocationManagerDelegateプロトコルを実装するクラスを指定する
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func timerUpdate() {
        locationManager.requestLocation()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            // 許可を求めるコードを記述する（後述）
            break
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            break
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            break
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            locationManager.activityType = .fitness
            locationManager.distanceFilter = 10.0
//            locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            print("緯度:\(location.coordinate.latitude) 経度:\(location.coordinate.longitude) 取得時刻:\(location.timestamp.description)")
            postData(latitude: Float(location.coordinate.latitude), longitude: Float(location.coordinate.longitude))
        }
    }
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        // TODO 時間ごとに位置情報を取得するか、動きがあった時のみ位置情報を取得するかを検討
        
        
    }

    func postData(latitude:Float, longitude: Float){
//        TODO set server url
        let url: URL = URL(string: "https://f2a6a908.ngrok.io/api/place")!
        let body: NSMutableDictionary = NSMutableDictionary()
        body.setValue(latitude, forKey: "latitude")
        body.setValue(longitude, forKey: "longitude")
//        TODO get user id automatically
//        this is test code
        body.setValue(1, forKey: "user_id")
        try? request.post(url: url, body: body, completionHandler: { data, response, error in
            // code
            if (error == nil) {
                print("success")
            } else {
                print("failed")
                print(error!)
            }
        })
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗しました")
    }
}

