//
//  ViewController.swift
//  Pomodoro for Myself
//
//  Created by ryo on 2020/02/05.
//  Copyright © 2020 ryo. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var startStopButton: UIButton!
    
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
        getTime = workTime
        timeDisplay.text = changeSeconds(getTime: workTime, secondsPased: secondsPased)
        progressBar.progress = 0.0
        startStopButton.setTitle("Start", for: .normal) // bottonTitle
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
        startStopButton.setTitle("Stop", for: .highlighted)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // stopボタンをタップした時の関数
    func timeStop() {
        startStopFlag = 0
        startStopButton.setTitle("Start", for: .highlighted)
        timer.invalidate()
    }
    
    // 経過時間を更新する関数
    @objc func updateTimer() {
        if secondsPased < getTime {
            secondsPased += 1
            timeDisplay.text = changeSeconds(getTime: getTime, secondsPased: secondsPased)
            progressBar.progress = Float(secondsPased) / Float(getTime)
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
            getTime = breakTime
        } else {
            workBreakFlag = 1
            getTime = workTime
        }
        secondsPased = 0
        timeDisplay.text = changeSeconds(getTime: getTime, secondsPased: secondsPased)
        progressBar.progress = 0.0
    }
}
