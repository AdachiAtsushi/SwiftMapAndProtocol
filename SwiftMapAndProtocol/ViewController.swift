//
//  ViewController.swift
//  SwiftMapAndProtocol
//
//  Created by 安達篤史 on 2020/06/20.
//  Copyright © 2020 Adachi Atsushi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, SearchLocationDelegate {
    
    // ========== 画面項目 ==========
    @IBOutlet weak var mapView: MKMapView!       // 地図
    @IBOutlet weak var addressLabel: UILabel!    // 住所ラベル
    @IBOutlet weak var settingButton: UIButton!  // 設定ボタン
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    
    // 住所ラベルに格納する住所を定義
    var addressString = String()
    
    // TODO
    var locManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定ボタンのスタイルを指定
        settingButton.backgroundColor = .white
        settingButton.layer.cornerRadius = 20.0
    }

    @IBAction func longPressTap(_ sender: UILongPressGestureRecognizer) {
        // タップ開始されたのを検知
        if sender.state == .began {
            
            // タップし終えた時を検知
        } else if sender.state == .ended {
            // 長押しした場所を変数に格納
            let tapPoint = sender.location(in: view)
            
            // タップした位置からMKMapView上の緯度、経度を取得
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            
            // 緯度、経度から住所を取得
            let lat = center.latitude
            let log = center.longitude
            
            // 緯度、経度より住所を取得するメソッドを呼び出す
            convert(lat: lat, log: log)
        }
        
    }
    
    // 緯度、経度より住所を取得するメソッド
    // lat: 緯度, log: 経度
    func convert(lat: CLLocationDegrees, log: CLLocationDegrees) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: log)
        
        geocoder.reverseGeocodeLocation(location) {
            (placeMark, error) in
            
            if let placeMark = placeMark {
                
                if let pm = placeMark.first {
                    
                    if pm.administrativeArea != nil || pm.locality != nil {
                        self.addressString = pm.name! + pm.administrativeArea! + pm.locality!
                    } else {
                        self.addressString = pm.name!
                    }
                    self.addressLabel.text = self.addressString
                }
            }
        }
    }
    
    // =========== IBActionの定義 ===========
    // NextViewControllerへ遷移するメソッド
    @IBAction func goToSearchVC(_ sender: Any) {
        
        performSegue(withIdentifier: "next", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            let nextVC = segue.destination as! NextViewController
            nextVC.delegate = self
        }
    }
    
    // ========== Delegateメソッド　==========
    func searchLocation(latitude: String, longitude: String) {
        
        if latitude.isEmpty != true && longitude.isEmpty != true {
            let latitudeString = latitude
            let longitudeString = longitude
            
            // 緯度、経度をコーディネート
            let coordinate = CLLocationCoordinate2DMake(Double(latitudeString)!, Double(longitudeString)!)
            
            // 表示範囲を指定
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            
            // 領域を指定
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            // 領域をMapViewに設定
            mapView.setRegion(region, animated: true)
            
            // 緯度、経度から住所へ変換
            convert(lat: Double(latitudeString)!, log: Double(longitudeString)!)
            
            // ラベルに表示
            addressLabel.text = addressString
            
            // 緯度、経度は取得できなかった場合
        } else {
            // ラベルに表示
            addressLabel.text = "表示できません"
        }
    }

    
}
