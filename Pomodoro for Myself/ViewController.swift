//
//  ViewController.swift
//  Pomodoro for Myself
//
//  Created by ryo on 2020/02/05.
//  Copyright © 2020 ryo. All rights reserved.
//

import UIKit
import AVFoundation
import MBCircularProgressBar

class ViewController: UIViewController {
    
    @IBOutlet weak var countResetButton: UIButton!
    @IBOutlet weak var progressCircle: MBCircularProgressBarView!
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var workBreakLabel: UILabel!
    
    var player: AVAudioPlayer!
    var timer = Timer()
    
    var workTime = 5 // 25minute -> 1500seconds
    var breakTime = 3 // 5minute -> 300seconds
    var secondsPased = 0 // 経過時間
    var getTime = 0 // get workTime or breakTime
    var workBreakFlag = 1 // 1 == work, 0 == break
    var startStopFlag = 0 // 1 == play, 0 == stop
    
    // 最初に画面を読み込んだ時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countResetButton.layer.borderWidth = 2
        countResetButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // ビューの生成
        let sampView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width/2-100, y: 60, width: 200, height: 200))
        self.view.addSubview(sampView)
        let gradientLayer = CAGradientLayer()
        // グラデーションレイヤーの領域の設定
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        
        
        // 青のグラデーションカラーの設定
        gradientLayer.colors = [UIColor(red: 0.2251946628, green: 0.8290438056, blue: 1, alpha: 1).cgColor,
                                UIColor(red: 0.1660510302, green: 0.5308232307, blue: 0.8241160512, alpha: 1).cgColor]
        // 上から下へグラデーション向きの設定
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y:1)
        // ビューにグラデーションレイヤーを追加
        sampView.layer.insertSublayer(gradientLayer, at:0)
        //ViewControllerのViewレイヤーにグラデーションレイヤーを挿入する
        self.view.layer.insertSublayer(gradientLayer, at:0)
        
    
        
        getTime = workTime
        progressCircle.value = 0.0
        //progressCircle.backgroundColor =
        timeDisplay.text = changeSeconds(getTime: workTime, secondsPased: secondsPased)
        workBreakLabel.text = "WORK"
        startStopButton.setTitle("START", for: .normal) // bottonTitle
        //view.backgroundColor = #colorLiteral(red: 0.3134402059, green: 0.7658284802, blue: 1, alpha: 1)
        progressCircle.progressColor = #colorLiteral(red: 0.9944506288, green: 0.8095949292, blue: 0.1892715096, alpha: 1)
        progressCircle.emptyLineColor = #colorLiteral(red: 0.9871311865, green: 0.9871311865, blue: 0.9871311865, alpha: 1)
        //button.setTitleColor(UIColor.red, for: .normal) // titleColor
    }
    
    //再生/停止ボタンを押した時の処理
    @IBAction func startStopPressed(_ sender: UIButton) {
        if startStopFlag == 0 {
            timeStart()
        } else {
            timeStop()
        }
    }
    
    // startボタンをタップした時の関数
    func timeStart() {
        startStopFlag = 1
        startStopButton.setTitle("STOP", for: .normal)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // stopボタンをタップした時の関数
    func timeStop() {
        startStopFlag = 0
        startStopButton.setTitle("START", for: .normal)
        timer.invalidate()
    }
    
    // 経過時間を更新する関数
    @objc func updateTimer() {
        if secondsPased < getTime {
            secondsPased += 1
            timeDisplay.text = changeSeconds(getTime: getTime, secondsPased: secondsPased)
            progressCircle.value = CGFloat((Float(secondsPased) / Float(getTime) * 100 ))
        } else {
            playSound()
            displayinitialization()
        }
    }
    
    // 音を鳴らす関数
    func playSound() {
        let url = Bundle.main.url(forResource: "callbell2", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
    
    // 経過時間を表示形式に変換する関数
    func changeSeconds(getTime: Int, secondsPased: Int)  -> String {
        let m = (getTime - secondsPased) / 60
        let s = (getTime - secondsPased) % 60
        return String(format: "%02d:%02d", m, s)
    }
    
    // 画面の初期化
    func displayinitialization() {
        if workBreakFlag == 1 {
            workBreakFlag = 0
            workBreakLabel.text = "BREAK"
            getTime = breakTime
            progressCircle.progressColor = #colorLiteral(red: 0.03194592521, green: 0.4165698886, blue: 0.5293766856, alpha: 1)
            progressCircle.emptyLineColor = #colorLiteral(red: 0.9871311865, green: 0.9871311865, blue: 0.9871311865, alpha: 1)
        } else {
            workBreakFlag = 1
            workBreakLabel.text = "WORK"
            getTime = workTime
//            view.backgroundColor = #colorLiteral(red: 0.009570271342, green: 0.8180718591, blue: 0.6716783642, alpha: 1)
            let sampView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width/2-100, y: 60, width: 200, height: 200))
            self.view.addSubview(sampView)
            let gradientLayer = CAGradientLayer()
            // グラデーションレイヤーの領域の設定
            gradientLayer.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
            // 緑のグラデーションカラーの設定
            gradientLayer.colors = [UIColor(red: 0.4861801267, green: 0.9166658521, blue: 0.327701956, alpha: 1).cgColor,
                                    UIColor(red: 0.007991780527, green: 0.7261779904, blue: 0.3112581074, alpha: 1).cgColor]
            // 上から下へグラデーション向きの設定
            gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint.init(x: 1, y:1)
            sampView.layer.insertSublayer(gradientLayer, at:1)
            self.view.layer.insertSublayer(gradientLayer, at:1)
            
            progressCircle.progressColor = #colorLiteral(red: 0.9944506288, green: 0.8095949292, blue: 0.1892715096, alpha: 1)
            progressCircle.emptyLineColor = #colorLiteral(red: 0.9871311865, green: 0.9871311865, blue: 0.9871311865, alpha: 1)

        }
        secondsPased = 0
        timeDisplay.text = changeSeconds(getTime: getTime, secondsPased: secondsPased)
        progressCircle.value = 0.0

    }
}
