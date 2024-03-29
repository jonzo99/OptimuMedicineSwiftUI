//
//  ContentView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 9/22/21.
//
// Test1
import SwiftUI
//import NotificationCenter
import UserNotifications
import AVFAudio


struct ContentView: View {
    //init() {
    //UIToolbar.appearance().barTintColor = UIColor.red
    // UITabBar.appearance().backgroundColor = UIColor.gray
    //UINavigationBar.appearance().backgroundColor = .lightGray
    //}
    @AppStorage("timerCountingHamilton") var timerCounting = false
    @AppStorage("timerCountingFree") var freeTimerCounting = false
    @StateObject var oxegenTimerHelper = OxegenTimeHelper()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            TabView {
                HamiltonView()
                    .environmentObject(oxegenTimerHelper)
                    .tabItem{
                        Image(systemName: "square.fill")
                        Text("HAMILTON")
                    }
                    .navigationBarTitle("Hamilton")
                FreeFlowView()
                    .environmentObject(oxegenTimerHelper)
                    .tabItem {
                        Image(systemName: "square.fill")
                        Text("Free Flow")
                    }
                    .navigationBarTitle("Hamilton")
            }
        }
        .onAppear() {
            let timePassedInBackground = Int(Date() - oxegenTimerHelper.timeExitedScreen) + 1
            if timerCounting {
                
                oxegenTimerHelper.hamCountDown = oxegenTimerHelper.hamCountDown - timePassedInBackground
            }
            
            if freeTimerCounting {
                oxegenTimerHelper.freeCountDown = oxegenTimerHelper.freeCountDown - timePassedInBackground
            }
        }
        .onDisappear() {
            oxegenTimerHelper.timeExitedScreen = Date()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            print("when the user swipes out of the app.")
        }
        .onReceive(timer) { time in
            
            if timerCounting {
                if (oxegenTimerHelper.hamCountDown > 0) {
                    oxegenTimerHelper.hamCountDown -= 1
                }
                if (oxegenTimerHelper.hamCountDown <= 0) {
                    timerCounting = false
                }
                // if i want to add a message when it hits a certain amount of seconds i should make phone vibrate show notification
                let time = oxegenTimerHelper.secondsToHoursMinutesSeconds(seconds: oxegenTimerHelper.hamCountDown)
                let timeString = oxegenTimerHelper.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
                oxegenTimerHelper.hamTimerText = timeString
            }
            
            if freeTimerCounting {
                if (oxegenTimerHelper.freeCountDown > 0) {
                    oxegenTimerHelper.freeCountDown -= 1
                }
                if (oxegenTimerHelper.freeCountDown <= 0) {
                    freeTimerCounting = false
                }
                // if i want to add a message when it hits a certain amount of seconds i should make phone vibrate show notification
                let time = oxegenTimerHelper.secondsToHoursMinutesSeconds(seconds: oxegenTimerHelper.freeCountDown)
                let timeString = oxegenTimerHelper.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
                oxegenTimerHelper.freeTimerText = timeString
            }
        }
    }
}


struct PrimaryLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 26, weight: .medium, design: .rounded))
    }
}
struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(1)
            .background(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
        //.shadow(color: .gray, radius: 10)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
