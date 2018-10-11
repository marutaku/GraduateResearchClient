//
//  AppDelegate.swift
//  GraduateResearchClient
//
//  Created by 丸山拓己 on 2018/09/15.
//  Copyright © 2018年 丸山拓己. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager!
    let request: Request = Request()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.locationManager = CLLocationManager() // インスタンスの生成
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
//        manager.activityType = .fitness
//        manager.startMonitoringVisits()
//        test code
        let latitude =  35.566181
        let longitude = 139.402674
        let arraivalDate = Date()
        let departureDate = Date()
        let accuracy = 0.000
        self.postData(latitude: Float(latitude), longitude: Float(longitude), accuracy: Float(accuracy), arraivalDate: arraivalDate, departureDate: departureDate)
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            break
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            break
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            break
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            self.locationManager.activityType = .fitness
            //            LocationManagerを起動
            self.locationManager.startMonitoringVisits()
            print("location manager起動")
            break
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        // TODO 時間ごとに位置情報を取得するか、動きがあった時のみ位置情報を取得するかを検討
        print("現在地 : \(visit.coordinate)")
        print("Accuracy : \(visit.horizontalAccuracy)")
        print("到着時間 : \(visit.arrivalDate)")
        print("出発時間 : \(visit.departureDate)")
        let latitude = visit.coordinate.latitude
        let longitude = visit.coordinate.longitude
        let arraivalDate = visit.arrivalDate
        let departureDate = visit.departureDate
        let accuracy = visit.horizontalAccuracy
        self.postData(latitude: Float(latitude), longitude: Float(longitude), accuracy: Float(accuracy), arraivalDate: arraivalDate, departureDate: departureDate)
    }
    
    func postData(latitude:Float, longitude: Float, accuracy: Float,  arraivalDate:Date, departureDate: Date){
        //        TODO set server url
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        let url: URL = URL(string: "https://9cf30a6a.ngrok.io/api/visited")!
        let body: NSMutableDictionary = NSMutableDictionary()
        body.setValue(latitude, forKey: "latitude")
        body.setValue(longitude, forKey: "longitude")
        body.setValue(accuracy, forKey: "accuracy")
        body.setValue(formatter.string(from: arraivalDate), forKey: "arraivalDate")
        body.setValue(formatter.string(from: departureDate), forKey: "departureDate")
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




