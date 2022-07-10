//
//  FreeFlowView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 10/7/21.
//
import SwiftUI

@available(iOS 15.0, *)
struct FreeFlowView: View {
    // create Local Storage
    // so I can store and always display
    // the values of the timer.
    
    // needs to be local because they go offline
    func getTotalSecondsLeft() -> Int {
        let numPsiTextField = Double(psiTextField) ?? 0
        let numRateTextField = Double(rateTextField) ?? 0
        
        if (numPsiTextField == 0.0 || numRateTextField == 0.0) {
            return 0
        } else {
            let totalTimeInSeconds = ((numPsiTextField - 200) * selectedTankSize / numRateTextField) * 60
            return Int(round(totalTimeInSeconds))
        }
    }
    
    @ObservedObject var notificationManager = LocalNotificationManager()
    @State var userNotificationCenter = UNUserNotificationCenter.current()
    @AppStorage("FreeSelectedTankSize") var selectedTankSize = 0.16
    @AppStorage("FreepsiTextField") var psiTextField = ""
    @AppStorage("FreerateTextField") var rateTextField = ""
    @State private var timerText = "00:00:00"
    @AppStorage("FreeTimeLeft") var timeText  = "00:00:00"
    @State private var stopStartText = "START"
    @AppStorage("timerCountingFree") var timerCounting = false
    @State var hrs2 = 0
    @State var min2 = 0
    @State var sec2 = 0
    @AppStorage("totalTimeInSec") var totalTimeInSec: Int = 0
    @AppStorage("totalTimeInSec2") var totalTimeInSec2: Int = 0
    @AppStorage("timePassedInBack") var timePassedInBack: Int = 0
    
    @State var first = false
    @State var isActive = true
    @AppStorage("isInForeground") var isInForeground = false
    
    @State private var showAlert: Bool = false
    
    @FocusState private var focusedField: Field?
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @AppStorage("countDowns") var countDowns: Int = 0
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        VStack {
            /*
            Text("Free Flow Oxygen Calculator")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.center) */
            Spacer()
            TankSizePicker(selectedTankSize: $selectedTankSize)
            
            timerTextField(leftLabel: "Tank Psi: ", placeholder: "tank psi", text: $psiTextField, focused: $focusedField, nextFocusedValue: .psiTextField)
            
            timerTextField(leftLabel: "Rate:         ", placeholder: "rate", text: $rateTextField, focused: $focusedField, nextFocusedValue: .rateTextField)
            
            
            CaluclatedTime(displayTimeText: $timeText)
            
            //Spacer()
            Text(timerText)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .frame(alignment: .center)
            //Spacer()
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    //self.countDown = getTotalSecondsLeft()
                    countDowns = 0
                    timerCounting = false
                    //self.timer.invalidate()
                    self.timerText = OxegenTimeHelper.makeTimeString(hours: 0, minutes: 0, seconds: 0)
                    stopStartText = "START"
                    //self.startStopBtn.setTitle("START", for: .normal)
                    //self.startStopBtn.setTitleColor(UIColor.green, for: .normal)
                    // this should cancel my notifications that I have created when I press the pause button
                    // I just added this
                    // if i press the reset button it should remove all the pending notifications request
                    userNotificationCenter.removeAllPendingNotificationRequests()
                    //psiTextField = 0.0
                    psiTextField = ""
                    rateTextField = ""
                    timeText = OxegenTimeHelper.makeTimeString(hours: 0, minutes: 0, seconds: 0)
                    hideKeyboard()
                }) {
                    Text("RESET")
                        .foregroundColor(Color(.red))
                        .padding()
                }
                .background(RoundedRectangle(cornerRadius: 10   , style: .continuous))
                .padding()
                
                Button(action: {
                    var total = getTotalSecondsLeft()
                    if (total <= 0) {
                        showAlert = true
                        total = 0
                    }
                    if (timerCounting == false) {
                        countDowns = total
                    }
                    let time = OxegenTimeHelper.secondsToHoursMinutesSeconds(seconds: total)
                    let timeString = OxegenTimeHelper.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
                    timeText = timeString
                    hideKeyboard()
                }) {
                    Text("CALC ")
                        .foregroundColor(Color(.red))
                        .padding()
                }
               
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding()
                
                Button(action: {
                    if countDowns <= 0 {
                        self.countDowns = getTotalSecondsLeft()
                        first = true
                    }
                    if (timerCounting) {
                        // this is when the the timer is paused and not counting down
                        timerCounting = false
                        //timer.invalidate()
                        stopStartText = "START"
                        //startStopBtn.setTitle("START", for: .normal)
                        // startStopBtn.setTitleColor(UIColor.green, for: .normal)
                        // this should cancel my notifications that I have created when I press the pause button
                        userNotificationCenter.removeAllPendingNotificationRequests()
                    } else {
                        if countDowns >= 600 {
                            let minuteLeft = countDowns - 599
                            print(countDowns)
                            notificationManager.sendLocalNotification(timeInterval: Double(minuteLeft), title: "10 mins Left", body: "FREE FLOW there is 10 mins left", sound: "critalAlarm.wav")
                        }
                        if countDowns >= 60 {
                            let tenseconds = countDowns - 59
                            print(countDowns)
                            notificationManager.sendLocalNotification(timeInterval: Double(tenseconds), title: "1 min Left", body: "FREE FLOW there is 1 mins left", sound: "critalAlarm.wav")
                        }
                        if countDowns >= 2 {
                            let twoSeconds = countDowns - 1
                            notificationManager.sendLocalNotification(timeInterval: Double(twoSeconds), title: "Timer is Done", body: "FREE FLOW Timer is done", sound: "critalAlarm.wav")
                        }
                        
                        timerCounting = true
                        stopStartText = "STOP  "
                        //startStopBtn.setTitle("STOP", for: .normal)
                        // startStopBtn.setTitleColor(UIColor.red, for: .normal)
                        // every time the this code is run the code in timerCounter is run once
                        //timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
                        //  timer.tolerance = 0.1
                        //RunLoop.current.add(timer,forMode: .common)
                        
                        // when the timer is counting down it does this part of the code
                        print(countDowns)
                        hideKeyboard()
                    }
                }) {
                    Text(stopStartText)
                        .foregroundColor(Color(.red))
                        .padding()
                }
                .background(RoundedRectangle(cornerRadius: 10   , style: .continuous))
                .padding()
                Spacer()
            }
        }
        .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .background:
                        print("App is in background")
                        print("App is Inactive")
                        totalTimeInSec = 0
                        let date = Date()
                        let calendar = Calendar.current
                        
                        // if i set the calender to this timezone I dont have to worry about
                        // the person going throught the time zones since i only care about how much seconds has passed
                        //calendar.timeZone = TimeZone(identifier: "UTC")
                        /*print("")
                         print("app move to the background")
                         print("")*/
                        let components = calendar.dateComponents([.hour, .year, .minute, .second], from: date)
                        /*print("all comp", components)*/
                        let hrs = calendar.component(.hour, from: date)
                        let min = calendar.component(.minute, from: date)
                        let sec = calendar.component(.second, from: date)
                        
                        totalTimeInSec = (min * 60) + (hrs * 3600) + sec
                        isInForeground = false
                    case .active:
                        
                        print("App is Active")
                        if(timerCounting) {
                            self.timer.upstream.connect()
                            //timer.start()
                        }
                        totalTimeInSec2 = 0
                        let date = Date()
                        let calendar = Calendar.current
                        /*print("")
                         print("App moved to foreGround")
                         print("") */
                        let components = calendar.dateComponents([.hour, .year, .minute, .second], from: date)
                        /*print("all comp", components) */
                        hrs2 = calendar.component(.hour, from: date)
                        min2 = calendar.component(.minute, from: date)
                        sec2 = calendar.component(.second, from: date)
                        
                        // what if I created a variable to pause the timer and its fake so i stop it every time
                        
                        
                        // i might need an if statement to check if c
                        totalTimeInSec2 = (min2 * 60) + (hrs2 * 3600) + sec2
                        /*print(totalTimeInSec2, "   ", totalTimeInSec)
                         print(first, "    ", timerCounting) */
                        if (first == true && timerCounting == true) {
                            first = false
                        }
                        timePassedInBack = (totalTimeInSec2 - totalTimeInSec)
                        print("\(timePassedInBack) = \(totalTimeInSec2) - \(totalTimeInSec)")
                        
                        print(timerCounting, isInForeground)
                        if (timerCounting == true && isInForeground == false) {
                            // I am subrtracting 2 because when the conversion happens between foreground and background i think i lose a second
                            countDowns = countDowns - (timePassedInBack + 1)
                        }
                        //
                        
                        isInForeground = true
                    case .inactive:
                        // so this does not work just having this code here because everytime i enter the app for some reason it shows that the app is inactive than it turns to active
                        print("App is Inactive")
                        self.timer.upstream.connect().cancel()
                        //self.timer.upstream.connect().pause()
                        //timer.cancel()
                        /*totalTimeInSec = 0
                        let date = Date()
                        let calendar = Calendar.current
                        
                        // if i set the calender to this timezone I dont have to worry about
                        // the person going throught the time zones since i only care about how much seconds has passed
                        //calendar.timeZone = TimeZone(identifier: "UTC")
                        /*print("")
                         print("app move to the background")
                         print("")*/
                        let components = calendar.dateComponents([.hour, .year, .minute, .second], from: date)
                        /*print("all comp", components)*/
                        hrs = calendar.component(.hour, from: date)
                        min = calendar.component(.minute, from: date)
                        sec = calendar.component(.second, from: date)
                        
                        totalTimeInSec = (min * 60) + (hrs * 3600) + sec
                        isInForeground = false*/
                    @unknown default:
                        print("New App state not yet introduced")
                    }
                }
        /*
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                print("FREEFLOW IS INACTIVE")
                isActive = false
            } else if newPhase == .active {
                print("FREEFLOW IS ACTIVE")
                print(timerCounting)
                print(isInForeground)
                if (timerCounting == true && isInForeground == false && isActive == true) {
                    // I am subrtracting 2 because when the conversion happens between foreground and background i think i lose a second
                    totalTimeInSec2 = 0
                    let date = Date()
                   // let currentAccumulatedTime = date.timeIntervalSince(lastDateObserved)
                    //lastDateObserved = date
                    let calendar = Calendar.current
                    /*print("")
                     print("App moved to foreGround")
                     print("") */
                    let components = calendar.dateComponents([.hour, .year, .minute, .second], from: date)
                    /*print("all comp", components) */
                    hrs2 = calendar.component(.hour, from: date)
                    min2 = calendar.component(.minute, from: date)
                    sec2 = calendar.component(.second, from: date)
                    
                    print(hrs2, min2, sec2)
                    
                    
                    // i might need an if statement to check if c
                    totalTimeInSec2 = (min2 * 60) + (hrs2 * 3600) + sec2
                    /*print(totalTimeInSec2, "   ", totalTimeInSec)
                     print(first, "    ", timerCounting) */
                    if (first == true && timerCounting == true) {
                        first = false
                    }
                    timePassedInBack = (totalTimeInSec2 - totalTimeInSec)
                    countDowns = countDowns - (timePassedInBack - 2)
                }
                isActive = true
                
            } else if newPhase == .background {
                print("FREEFLOW IS IN BACKGROUND")
            }
        }*/
        .onSubmit {
            switch focusedField {
            case .psiTextField:
                focusedField = .rateTextField
            default:
                print("you have submitted")
                var total = getTotalSecondsLeft()
                if (total <= 0) {
                    showAlert = true
                    total = 0
                }
                if (timerCounting == false) {
                    countDowns = total
                }
                let time = OxegenTimeHelper.secondsToHoursMinutesSeconds(seconds: total)
                let timeString = OxegenTimeHelper.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
                timeText = timeString
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Calculation needs to be greater than 0"), dismissButton: .default(Text("OK")))
        }/*
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            
            totalTimeInSec2 = 0
            let date = Date()
            let calendar = Calendar.current
            /*print("")
             print("App moved to foreGround")
             print("") */
            let components = calendar.dateComponents([.hour, .year, .minute, .second], from: date)
            /*print("all comp", components) */
            hrs2 = calendar.component(.hour, from: date)
            min2 = calendar.component(.minute, from: date)
            sec2 = calendar.component(.second, from: date)
            
            print(hrs2, min2, sec2)
            
            
            // i might need an if statement to check if c
            totalTimeInSec2 = (min2 * 60) + (hrs2 * 3600) + sec2
            /*print(totalTimeInSec2, "   ", totalTimeInSec)
             print(first, "    ", timerCounting) */
            if (first == true && timerCounting == true) {
                first = false
            }
            timePassedInBack = (totalTimeInSec2 - totalTimeInSec)
            /*print(totalTimeInSec2, "total time insec")
             print(timePassedInBack, "this is how much time has passed in the back")
             print(countDown, "is in foreground") */
            print(timerCounting, isInForeground)
            if (timerCounting == true && isInForeground == false) {
                // I am subrtracting 2 because when the conversion happens between foreground and background i think i lose a second
                countDowns = countDowns - (timePassedInBack - 2)
            }
            
            isInForeground = true
            /*print(countDown, "app is in foreground2")*/
            print("THE APP HAS ENTERED THE foreground")
        }*/
        .onAppear(perform: {
            print(totalTimeInSec)
            print(timePassedInBack)
            print(timerCounting)
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            print("yeah the terminated your app boi")
            //countDowns = 600
            //timerCounting = false
            print(countDowns)
            
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            print("I wonder when does this happen")
        }
        /*
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            //self.timerCounting = false
            print("app entered background")
            totalTimeInSec = 0
            let date = Date()
            let calendar = Calendar.current
            
            // if i set the calender to this timezone I dont have to worry about
            // the person going throught the time zones since i only care about how much seconds has passed
            //calendar.timeZone = TimeZone(identifier: "UTC")
            /*print("")
             print("app move to the background")
             print("")*/
            let components = calendar.dateComponents([.hour, .year, .minute, .second], from: date)
            /*print("all comp", components)*/
            hrs = calendar.component(.hour, from: date)
            min = calendar.component(.minute, from: date)
            sec = calendar.component(.second, from: date)
            
            totalTimeInSec = (min * 60) + (hrs * 3600) + sec
            isInForeground = false
            /*
             print(totalTimeInSec)
             print(hrs, min, sec) */
        }*/
        .onReceive(timer) { time in
            guard timerCounting else { return }
            print(countDowns, "this is in timerCounter()")
            //countDown -= 1
            if (countDowns > 0) {
                countDowns -= 1
            }
            if (countDowns <= 0) {
                //timer.invalidate()
                timerCounting = false
            }
            // if i want to add a message when it hits a certain amount of seconds i should make phone vibrate show notification
            let time = OxegenTimeHelper.secondsToHoursMinutesSeconds(seconds: countDowns)
            let timeString = OxegenTimeHelper.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
            timerText = timeString
        }
    }
   
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct FreeFlowView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            FreeFlowView()
        } else {
            // Fallback on earlier versions
        }
    }
}
