//
//  NextViewController.swift
//  SwiftMapAndProtocol
//
//  Created by 安達篤史 on 2020/06/20.
//  Copyright © 2020 Adachi Atsushi. All rights reserved.
//

import UIKit

protocol  SearchLocationDelegate {
    
    func searchLocation (latitude: String, longitude: String)
    
}

class NextViewController: UIViewController {

    // ========== 画面項目 ==========
    @IBOutlet weak var latitudeText: UITextField!   // 緯度
    @IBOutlet weak var longitudeText: UITextField!  // 経度
    
    var delegate:SearchLocationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // ========== IBActionを定義 ==========
    // OKボタン押下時の挙動を定義
    // テキスト「緯度」、「経度」に入力された値を取得し、遷移元画面に値(緯度、経度)を連携する
    @IBAction func okAction(_ sender: Any) {
        // テキスト「緯度」、「経度」に入力された値を取得
        let latitude = latitudeText.text!
        let longitude = longitudeText.text!
        
        // テキスト「緯度」、「経度」に入力値があれば遷移
        if latitudeText.text != nil && longitudeText.text != nil {
            // 遷移元の画面に移譲
            delegate?.searchLocation(latitude: latitude, longitude: longitude)
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}
