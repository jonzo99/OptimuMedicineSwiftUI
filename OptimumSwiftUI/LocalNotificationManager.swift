//
//  LocalNotificationManager.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 9/26/21.
//

import Foundation
import UserNotifications
import SwiftUI


class LocalNotificationManager: ObservableObject {
   var notifications = [Notification]()
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.criticalAlert,.sound,.badge]) { granted, error in
            if granted == true && error == nil {
                print("notifications permitted")
            } else {
                print("Notifications not permitted")
            }
            
        }
    }
    func sendLocalNotification(timeInterval: Double, title: String, body: String, sound: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = .criticalSoundNamed(UNNotificationSoundName.init(rawValue: sound), withAudioVolume: 1.0)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        // create a unique indentifier to be able to get multiople notifications
        let identifier = UUID.init().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        print(trigger.timeInterval, "jfkdsfjs")
        print(identifier)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        //userNotificationCenter.add(request) { (error) in
        //    if let error = error {
        //        print("Notification Error: ", error)
       //     }
       // }
    }
    
}

class OxegenTimeHelper: ObservableObject {
    
    // my hamilton timer is working great i only got off by 3 seconds
    // after multiple times leaving and entering.
    
    // @AppStorage("timerCountingFree") var timerCounting = false
    
    /*
     I will also need to put the values of if they are counting down to be stored here
     */
    @Published var timeExitedScreen: Date {
        didSet {
            UserDefaults.standard.set(timeExitedScreen, forKey: "timeExitedScreen")
        }
    }
    @Published var hamCountDown: Int {
        didSet {
            UserDefaults.standard.set(hamCountDown, forKey: "HamCountDown")
        }
    }
    @Published var hamTimerText: String = "00:00:00"
    
    
    @Published var freeCountDown: Int {
        didSet {
            UserDefaults.standard.set(freeCountDown, forKey: "FreeCountDown")
        }
    }
    @Published var freeTimerText: String = "00:00:00"
    init() {
        //self.hamTimerCounting = UserDefaults.standard.bool(forKey: "timerCountingHamilton")
        self.timeExitedScreen = UserDefaults.standard.object(forKey: "timeExitedScreen") as? Date ?? Date()
        self.hamCountDown = UserDefaults.standard.integer(forKey: "HamCountDown")
        self.freeCountDown = UserDefaults.standard.integer(forKey: "FreeCountDown")
        
    }
     func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    // I dont think I should make these static functions
    // But I would need to do more researh
     func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
}
