////
////  AppDelegate.swift
////  Pomodoro for Myself
////
////  Created by ryo on 2020/02/05.
////  Copyright © 2020 ryo. All rights reserved.
////
//
//import UIKit
//import UserNotifications
//import NotificationCenter
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
////        let center = UNUserNotificationCenter.current()
////        center.requestAuthorization(options: [.alert, .badge, .sound]) {(granted, error) in
////            if granted {
////                print("許可する")
////            } else {
////                print("許可しない")
////            }
////        }
//        UNUserNotificationCenter.current().requestAuthorization(
//        options: [.alert, .sound, .badge]){
//            (granted, _) in
//            if granted{
//                UNUserNotificationCenter.current().delegate = self as! UNUserNotificationCenterDelegate
//            }
//        }
//        return true
//    }
//
//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//
//    //上記のNotificatioを５秒後に受け取る関数
//    //ポップアップ表示のタイミングで呼ばれる関数
//    //（アプリがアクティブ、非アクテイブ、アプリ未起動,バックグラウンドでも呼ばれる）
//
//
////    func userNotificationCenter(_ center: UNUserNotificationCenter,
////                                willPresent notification: UNNotification,
////                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
////        completionHandler([.sound, .alert])
////    }
//    //バックグラウンド遷移移行直前に呼ばれる
//    func applicationWillResignActive(_ application: UIApplication) {
//       // 新しいタスクを登録
//        backgroundTaskID = application.beginBackgroundTask {
//            [weak self] in
//            application.endBackgroundTask((self?.backgroundTaskID)!)
//            self?.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
//        }
//    }
//
//}
//


import UIKit
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var window: UIWindow?
 
    var backgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 通知許可の取得
        UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .sound, .badge]){
            (granted, _) in
            if granted{
                UNUserNotificationCenter.current().delegate = self
            }
        }
        return true
    }
 
    //バックグラウンド遷移移行直前に呼ばれる
    func applicationWillResignActive(_ application: UIApplication) {
       // 新しいタスクを登録
        backgroundTaskID = application.beginBackgroundTask {
            [weak self] in
            application.endBackgroundTask((self?.backgroundTaskID)!)
            self?.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
    }
    //アプリがアクティブになる度に呼ばれる
    func applicationDidBecomeActive(_ application: UIApplication) {
        //タスクの解除
        application.endBackgroundTask(self.backgroundTaskID)
    }
}
 
extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // アプリ起動中でもアラートと音で通知
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // バックグラウンドで来た通知をタップしてアプリ起動したら呼ばれる
        completionHandler()
    }
}
