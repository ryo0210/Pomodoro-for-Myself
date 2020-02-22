//
//  GetColor.swift
//  Pomodoro for Myself
//
//  Created by ryo on 2020/02/07.
//  Copyright © 2020 ryo. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import AVFoundation

struct GetData {
    
    var player: AVAudioPlayer!
    var timer = Timer()
    
    var workTime: Int = 5 // 25minute -> 1500seconds
    var breakTime: Int = 3// 5minute -> 300seconds
    var longBreakTime: Int = 4
    var intervalOften: Int = 4 // どのくらいの頻度で長時間休憩を行うか
    var workCount: Int = 0 // 何回workしたか
    var secondsPased: Int = 0 //　経過時間
    var getTime: Int  = 0 // get workTime or breakTime
    
    var doString: String = "work"
    
    var workBreakFlag: Int = 1 // 1 == work, 0 == break
    var intervalFlag: Int = 1 // 1 == on, 0 == off
    var startStopFlag: Int = 0 // 1 == stop, 0 == start
    var todayCount: Int = 0
    // var totalCount: Int = 0 未実装

    let blueView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width/2-100, y: 60, width: 200, height: 200))
    let greenView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width/2-100, y: 60, width: 200, height: 200))
    let blueGradientLayer = CAGradientLayer()
    let greenGradientLayer = CAGradientLayer()
    
    let playImage = UIImage(systemName: "play.fill")
    let pauseImage = UIImage(systemName: "pause.fill")
    let imageState = UIControl.State.normal
    
    // 経過時間を表示形式に変換する関数
    func changeSeconds(getTime: Int, secondsPased: Int)  -> String {
        let m = (getTime - secondsPased) / 60
        let s = (getTime - secondsPased) % 60
        return String(format: "%02d:%02d", m, s)
    }
    
    // 音を鳴らす関数
    mutating func playSound() {
        let url = Bundle.main.url(forResource: "callbell2", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
}
