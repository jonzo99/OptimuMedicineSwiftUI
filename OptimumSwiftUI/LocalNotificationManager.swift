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

class OxegenTimeHelper {
    static func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    // I dont think I should make these static functions
    // But I would need to do more researh
    static func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
}
