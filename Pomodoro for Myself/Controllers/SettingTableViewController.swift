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
//        mainVC.loadView()
//        mainVC.viewDidLoad()
        if getData.intervalFlag == 1 {
            mainVC.intervalCounter.text = "\(String(getData.workCount)) / \(getData.intervalOften)"
        // 長時間休憩がオフの時
        } else {
            mainVC.intervalCounter.text = "off"
        }

    }
    
    
    
    
    
    
   
    

    // MARK: - Table view data source
    
    //セクションの数
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 2
//    }
//
//    // セルの数
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 3
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//        //cell.textLabel?.text = array[indexPath.row]// 新しく付け足した
//
//
//        return cell
//    }
//
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
