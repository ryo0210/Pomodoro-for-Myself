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
    
//    public weak var progressCircle: MBCircularProgressBarView!
//    public weak var timeDisplay: UILabel!
//    public weak var workBreakLabel: UILabel!
    
    public weak var vc: ViewController!
    
    var player: AVAudioPlayer!
    var timer = Timer()
    
    public var workTime: Int = 5 // 25minute -> 1500seconds
    public var breakTime: Int = 3 // 5minute -> 300seconds
    public var secondsPased: Int = 0 //
    public var getTime: Int  = 0 // get workTime or breakTime
    public var workBreakFlag: Int = 1 // 1 == work, 0 == break
    public var startStopFlag: Int = 1 // 1 == stop, 0 == start
    public var jobName: String = "BREAK"
    public var timeString: String = "25:00"
    
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
