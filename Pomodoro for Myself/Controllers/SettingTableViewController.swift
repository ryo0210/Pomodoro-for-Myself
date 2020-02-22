//
//  SettingTableViewController.swift
//  Pomodoro for Myself
//
//  Created by ryo on 2020/02/11.
//  Copyright © 2020 ryo. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController, UIAdaptivePresentationControllerDelegate {
    @IBOutlet weak var workTimeLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var longBreakTimeLabel: UILabel!
    
    @IBOutlet weak var workStepper: UIStepper!
    @IBOutlet weak var breakStepper: UIStepper!
    @IBOutlet weak var intervalStepper: UIStepper!
    @IBOutlet weak var longBreakStepper: UIStepper!
    
    @IBOutlet weak var intervalSwitch: UISwitch!
    
    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard
    
    var getData = GetData()
    
    var timePicker: UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workStepper.value = Double(getData.workTime)
        workTimeLabel.text = String(format: "%.0fmin", workStepper.value)
        
        breakStepper.value = Double(getData.breakTime)
        breakTimeLabel.text = String(format: "%.0fmin", breakStepper.value)
        
        intervalStepper.value = Double(getData.intervalOften)
        intervalLabel.text = String(format: "%.0f回", intervalStepper.value)
        
        longBreakStepper.value = Double(getData.longBreakTime)
        longBreakTimeLabel.text = String(format: "%.0fmin", longBreakStepper.value)
        
        let intervalSwitchBool = userDefaults.bool(forKey: "bool01")
        intervalSwitch.setOn(intervalSwitchBool, animated: true)
    }
    
    @IBAction func workTimeSteperPressed(_ sender: UIStepper) {
        workTimeLabel.text = String(format: "%.0fmin", sender.value)
        getData.workTime = Int(sender.value)
    }
    
    @IBAction func breakTimeSteperPressed(_ sender: UIStepper) {
        breakTimeLabel.text = String(format: "%.0fmin", sender.value)
        getData.breakTime = Int(sender.value)
    }
    
    @IBAction func intervalSteperPressed(_ sender: UIStepper) {
        intervalLabel.text = String(format: "%.0f回", sender.value)
        getData.intervalOften = Int(sender.value)
    }
    
    @IBAction func longBreakTimeSteperPressed(_ sender: UIStepper) {
        longBreakTimeLabel.text = String(format: "%.0fmin", sender.value)
        getData.longBreakTime = Int(sender.value)
    }
    
    
    @IBAction func intervalSwitchPressed(_ sender: UISwitch) {
        if sender.isOn {
            getData.intervalFlag = 1
        } else {
            getData.intervalFlag = 0
        }
        userDefaults.set(sender.isOn, forKey: "bool01")
    }
    
    
    // メイン画面に戻る画面遷移が開始する時に呼ばれます。
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // メイン画面の ViewController を取得。
        let mainVC = presentationController.presentingViewController as! ViewController
        // メイン画面に値を返す。
        mainVC.getData.workTime = getData.workTime
        mainVC.getData.breakTime = getData.breakTime
        mainVC.getData.intervalOften = getData.intervalOften
        mainVC.getData.longBreakTime = getData.longBreakTime
        mainVC.getData.intervalFlag = getData.intervalFlag
        // 長時間休憩がオンの時
        if getData.intervalFlag == 1 {
            mainVC.intervalCounter.text = "\(String(mainVC.getData.workCount)) / \(mainVC.getData.intervalOften)"
        // 長時間休憩がオフの時
        } else {
            mainVC.intervalCounter.text = "off"
        }

    }
}
