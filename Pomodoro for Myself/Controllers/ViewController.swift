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

    let blueView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width/2-100, y: 60, width: 200, height: 200))
    let greenView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width/2-100, y: 60, width: 200, height: 200))
    let blueGradientLayer = CAGradientLayer()
    let greenGradientLayer = CAGradientLayer()
    
    @IBOutlet weak var progressCircle: MBCircularProgressBarView!
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var workBreakLabel: UILabel!
    @IBOutlet weak var intervalCounter: UILabel!
    @IBOutlet weak var countResetButton: UIButton!
    @IBOutlet weak var totalCounter: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    
    var player: AVAudioPlayer!
    var timer = Timer()

    var workTime = 5 // 25minute -> 1500seconds
    var breakTime = 3 // 5minute -> 300seconds
    var longBreak = 4
    var secondsPased = 0 // 経過時間
    var getTime = 0 // get workTime or breakTime
    var workBreakFlag = 1 // 0 == work, 1 == break
    var startStopFlag = 0 // 0 == stop, 1 == play
    var intervalCount = 0
    var todayCount = 0
    var totalCount = 0
    let playImage = UIImage(systemName: "play.fill")
    let pauseImage = UIImage(systemName: "pause.fill")
    let imageState = UIControl.State.normal
    
    
    var getData = GetData()
    
    // 最初に画面を読み込んだ時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        startStopButton.setImage(playImage, for: imageState)

        // 背景色の定義-------------------
        blueGradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        blueGradientLayer.endPoint = CGPoint.init(x: 1, y:1)
        greenGradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        greenGradientLayer.endPoint = CGPoint.init(x: 1, y:1)
        // グラデーションレイヤーの領域の設定
        blueGradientLayer.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        greenGradientLayer.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        // 青のグラデーションカラーの設定
        blueGradientLayer.colors = [UIColor(red: 0.2251946628, green: 0.8290438056, blue: 1, alpha: 1).cgColor,
                                    UIColor(red: 0.1660510302, green: 0.5308232307, blue: 0.8241160512, alpha: 1).cgColor]
        // 緑のグラデーションカラーの設定
        greenGradientLayer.colors = [UIColor(red: 0.4861801267, green: 0.9166658521, blue: 0.327701956, alpha: 1).cgColor,
                                     UIColor(red: 0.007991780527, green: 0.7261779904, blue: 0.3112581074, alpha: 1).cgColor]
        // ビューにグラデーションレイヤーを追加
        greenView.layer.insertSublayer(greenGradientLayer, at:0)
        blueView.layer.insertSublayer(blueGradientLayer, at:0)
        self.view.layer.insertSublayer(blueGradientLayer, at:0)
        // ----------------------------
        
        displayinit()
    }
    
    //再生/停止ボタンを押した時の処理
    @IBAction func startStopPressed(_ sender: UIButton) {
        timePressed()
    }
    
    @IBAction func countResetPressed(_ sender: UIButton) {
        countReset()
    }
    
    @IBAction func settingPressed(_ sender: UIButton) {
        let secondVC = SecondViewController()
        
        self.present(secondVC, animated: true, completion: nil)
    }
    
    
    
    
    
    //画面の初期化
    func displayinit() {
        if workBreakFlag == 0 {
            workBreakFlag = 1
            workBreakLabel.text = "BREAK"
            if intervalCount < 4 {
                getTime = breakTime
            } else {
                getTime = longBreak
            }
            //ViewControllerのViewレイヤーにグラデーションレイヤーを挿入する
            self.view.layer.insertSublayer(blueGradientLayer, at:0)
        } else {
            workBreakFlag = 0
            workBreakLabel.text = "WORK"
            getTime = workTime
            self.view.layer.insertSublayer(greenGradientLayer, at:0)
        }
        secondsPased = 0
        timeDisplay.text = getData.changeSeconds(getTime: getTime, secondsPased: secondsPased)
        progressCircle.value = 0.0
    }

    // startStopボタンをタップした時の関数
    func timePressed() {
        if startStopFlag == 0 {
            startStopFlag = 1
            startStopButton.setImage(pauseImage, for: imageState)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else {
            startStopFlag = 0
            startStopButton.setImage(playImage, for: imageState)
            timer.invalidate()
        }
    }

    //経過時間を更新する関数
    @objc func updateTimer() {
        if secondsPased < getTime { // タイマーを1秒毎に呼び出す
            secondsPased += 1
            timeDisplay.text = getData.changeSeconds(getTime: getTime, secondsPased: secondsPased)
            progressCircle.value = CGFloat((Float(secondsPased) / Float(getTime) * 100 ))
        } else { // 時間が終了した時の処理
            if workBreakFlag == 0 { // workが終了した時の処理
                intervalCount += 1
                todayCount += 1
                totalCount += 1
                intervalCounter.text = "\(String(intervalCount)) / 4"
                totalCounter.text = String(todayCount)
            } else if workBreakFlag == 1 && intervalCount == 4 { // breakが終了し、かつ、intervalCountが4の時
                intervalCount = 0
                intervalCounter.text = "\(String(intervalCount)) / 4"
            }
            getData.playSound()
            displayinit()
        }
    }
    
    // work && stopの状態にさせる
    func countReset() {
        startStopFlag = 1 // startStopFlag = 1をしてstart状態にさせてからtimePressed()を呼び出し、stop状態にさせる。
        timePressed()
        workBreakFlag = 1 // workBreakFlag = 1をしbreak状態にしてからdisplayinit()を呼び出し、work状態にさせる。
        displayinit()
        intervalCount = 0
    }
}
