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
    
    var getData = GetData()
    
    // 最初に画面を読み込んだ時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        startStopButton.setImage(getData.playImage, for: getData.imageState)

        // 背景色の定義-------------------
        getData.blueGradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        getData.blueGradientLayer.endPoint = CGPoint.init(x: 1, y:1)
        getData.greenGradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        getData.greenGradientLayer.endPoint = CGPoint.init(x: 1, y:1)
        // グラデーションレイヤーの領域の設定
        getData.blueGradientLayer.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        getData.greenGradientLayer.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        // 青のグラデーションカラーの設定
        getData.blueGradientLayer.colors = [UIColor(red: 0.2251946628, green: 0.8290438056, blue: 1, alpha: 1).cgColor,
                                    UIColor(red: 0.1660510302, green: 0.5308232307, blue: 0.8241160512, alpha: 1).cgColor]
        // 緑のグラデーションカラーの設定
        getData.greenGradientLayer.colors = [UIColor(red: 0.4861801267, green: 0.9166658521, blue: 0.327701956, alpha: 1).cgColor,
                                     UIColor(red: 0.007991780527, green: 0.7261779904, blue: 0.3112581074, alpha: 1).cgColor]
        // ビューにグラデーションレイヤーを追加
        getData.greenView.layer.insertSublayer(getData.greenGradientLayer, at:0)
        getData.blueView.layer.insertSublayer(getData.blueGradientLayer, at:0)
        self.view.layer.insertSublayer(getData.blueGradientLayer, at:0)
        // ----------------------------
        
        getData.workBreakFlag = 1
        displayinit()
    }
    
    //再生/停止ボタンを押した時の処理
    @IBAction func startStopPressed(_ sender: UIButton) {
        timePressed()
    }
    
    // countResetButtonを押した時の処理
    @IBAction func countResetPressed(_ sender: UIButton) {
        countReset()
    }
    
    @IBAction func settingPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "reuseIdentifier", sender: self)
    }
    
    // メイン画面から設定画面に遷移するときの処理を追加
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // メイン画面から設定画面に遷移するセグエが reuseIdentifier の場合
        if segue.identifier == "reuseIdentifier" {
            // 戻るときの処理を設定画面で行うための設定
            segue.destination.presentationController?.delegate = (segue.destination as! UIAdaptivePresentationControllerDelegate)
            // 設定画面に遷移する時に、getDataの値を返す
            let settingVC = segue.destination as! SettingTableViewController
            settingVC.getData.workTime = getData.workTime
            settingVC.getData.breakTime = getData.breakTime
            settingVC.getData.longBreakTime = getData.longBreakTime
            settingVC.getData.intervalOften = getData.intervalOften
            settingVC.getData.intervalFlag = getData.intervalFlag
        }
    }
    
    //画面の初期化
    func displayinit() {
        // breakの時
        if getData.workBreakFlag == 0 {
            getData.workBreakFlag = 1
            workBreakLabel.text = "BREAK"
            // 4回workしたら長時間休憩休憩をする
            getData.getTime = getData.breakTime
            // 長時間休憩がオンの時かつ、work数がインターバルの頻度より多い時に休憩時間を長時間休憩にする
            if getData.intervalFlag == 1 && getData.workCount >= getData.intervalOften{
                getData.getTime = getData.longBreakTime
            }
            //ViewControllerのViewレイヤーにグラデーションレイヤーを挿入する
            self.view.layer.insertSublayer(getData.blueGradientLayer, at:0)
        // workの時
        } else {
            getData.workBreakFlag = 0
            workBreakLabel.text = "WORK"
            getData.getTime = getData.workTime
            self.view.layer.insertSublayer(getData.greenGradientLayer, at:0)
        }
        getData.secondsPased = 0
        timeDisplay.text = getData.changeSeconds(getTime: getData.getTime, secondsPased: getData.secondsPased)
        progressCircle.value = 0.0
    }

    // startStopボタンをタップした時の関数
    func timePressed() {
        // スタートボタンを押した時
        if getData.startStopFlag == 0 {
            getData.startStopFlag = 1
            startStopButton.setImage(getData.pauseImage, for: getData.imageState)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        // ストップボタンを押した時
        } else {
            getData.startStopFlag = 0
            startStopButton.setImage(getData.playImage, for: getData.imageState)
            timer.invalidate()
        }
    }

    //経過時間を更新する関数
    @objc func updateTimer() {
        // タイマーを1秒毎に呼び出す
        if getData.secondsPased < getData.getTime {
            getData.secondsPased += 1
            timeDisplay.text = getData.changeSeconds(getTime: getData.getTime, secondsPased: getData.secondsPased)
            progressCircle.value = CGFloat((Float(getData.secondsPased) / Float(getData.getTime) * 100 ))
        // 時間が終了した時の処理
        } else {
            // workが終了した時の処理
            if getData.workBreakFlag == 0 {
                getData.todayCount += 1
                // getData.totalCount += 1 //未実装
                // 長時間休憩がオンの時
                if getData.intervalFlag == 1 {
                    getData.workCount += 1
                    intervalCounter.text = "\(String(getData.workCount)) / \(getData.intervalOften)"
                }
                totalCounter.text = String(getData.todayCount)
            }
            // 長時間休憩がオンの時かつ、breakが終了かつ、intervalCountが4の時
            if getData.intervalFlag == 1 && getData.workBreakFlag == 1 && getData.workCount >= getData.intervalOften {
                getData.workCount = 0
                intervalCounter.text = "\(String(getData.workCount)) / \(getData.intervalOften)"
            }
            getData.playSound()
            displayinit()
        }
    }
    
    // work && stopの状態にさせる
    func countReset() {
        getData.startStopFlag = 1 // startStopFlag = 1をしてstart状態にさせてからtimePressed()を呼び出し、stop状態にさせる。
        timePressed()
        getData.workBreakFlag = 1 // workBreakFlag = 1をしbreak状態にしてからdisplayinit()を呼び出し、work状態にさせる。
        displayinit()
        getData.workCount = 0
        intervalCounter.text = "\(String(getData.workCount)) / \(getData.intervalOften)"
    }
}
