////
////  GetColor.swift
////  Pomodoro for Myself
////
////  Created by ryo on 2020/02/07.
////  Copyright © 2020 ryo. All rights reserved.
////
//
//import UIKit
//
//class GetColor: UIViewController {
//    var data: Data
//    // ビューの生成
////    let blueView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width/2-100, y: 60, width: 200, height: 200))
////    let greenView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width/2-100, y: 60, width: 200, height: 200))
//
////    let blueGradientLayer = CAGradientLayer()
////    let greenGradientLayer = CAGradientLayer()
//
//    blueGradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
//    blueGradientLayer.endPoint = CGPoint.init(x: 1, y:1)
//    greenGradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
//    greenGradientLayer.endPoint = CGPoint.init(x: 1, y:1)
//
//    // グラデーションレイヤーの領域の設定
//    blueGradientLayer.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
//    greenGradientLayer.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
//
//
//    // 青のグラデーションカラーの設定
//    blueGradientLayer.colors = [UIColor(red: 0.2251946628, green: 0.8290438056, blue: 1, alpha: 1).cgColor,
//                            UIColor(red: 0.1660510302, green: 0.5308232307, blue: 0.8241160512, alpha: 1).cgColor]
//    // 緑のグラデーションカラーの設定
//    greenGradientLayer.colors = [UIColor(red: 0.4861801267, green: 0.9166658521, blue: 0.327701956, alpha: 1).cgColor,
//                            UIColor(red: 0.007991780527, green: 0.7261779904, blue: 0.3112581074, alpha: 1).cgColor]
//
//    // ビューにグラデーションレイヤーを追加
//    blueView.layer.insertSublayer(blueGradientLayer, at:0)
//    greenView.layer.insertSublayer(greenGradientLayer, at:1)
//    //ViewControllerのViewレイヤーにグラデーションレイヤーを挿入する
//    self.view.layer.insertSublayer(blueGradientLayer, at:0)
//    self.view.layer.insertSublayer(greenGradientLayer, at:1)
//
//    self.view.sendSubviewToBack(blueView)
//
//}
