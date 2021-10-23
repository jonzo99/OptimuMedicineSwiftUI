//
//  FreeFlowView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 10/7/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct FreeFlowView: View {
    
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
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func makeTimeString(hours: Int, minutes: Int, seconds : Int) ->  String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }

    
    @ObservedObject var notificationManager = LocalNotificationManager()
    @State var userNotificationCenter = UNUserNotificationCenter.current()
    @State private var selectedTankSize = 0.16
   // @State var psiTextField = 0.0
    @State var psiTextField = ""
    @State private var rateTextField = ""
    @State private var timerText = "00:00:00"
    @State private var timeText  = "00:00:00"
    @State private var stopStartText = "START"
    @State private var timerCounting = false
    @State var hrs = 0
    @State var min = 0
    @State var sec = 0
    @State var hrs2 = 0
    @State var min2 = 0
    @State var sec2 = 0
    @State var diffHrs = 0
    @State var diffMins = 0
    @State var diffSecs = 0
    @State var totalTimeInSec = 0
    @State var totalTimeInSec2 = 0
    @State var timePassedInBack = 0
    @State var first = false
    
    @State var isInForeground = true
    
   
    @State private var showAlert: Bool = false
    
    enum Field {
        case psiTextField
        case rateTextField
    }

    @FocusState private var focusedField: Field?
    //@State private var isActive = false
    //@State var timer = Timer()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var countDown = 0
    var body: some View {
        //onTapGesture {
        //    print("ive been tapped")
        //}
        //let tap = UITapGestureRecognizer(target: View.self, action: #selector(UIView.endEditing))
        
        VStack {
            Text("Free Flow Oxygen Calculator")
                .font(.system(.largeTitle, design: .rounded))
            //.font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top,25)
            Spacer()
            HStack {
                Text("Tank size:")
                    .modifier(PrimaryLabel())
                Spacer()
                VStack {
                    Picker("tanksize", selection: $selectedTankSize) {
                        Text("D").tag(0.16)
                        Text("E").tag(0.28)
                        Text("M").tag(1.56)
                        Text("K").tag(3.14)
                        
                    }.pickerStyle(SegmentedPickerStyle())
                }
                .frame(width: 200)
                .multilineTextAlignment(.center)
            }
            .padding(.bottom)
            .padding(.leading,20)
            .padding(.trailing,20)
            
            
            HStack {
                Text("Tank Psi: ")
                    .modifier(PrimaryLabel())
                Spacer()
                TextField("tank size", text: $psiTextField, onEditingChanged: { changed in
                    if (changed == true) {
                        psiTextField = ""
                    }
                })
                    .focused($focusedField, equals: .psiTextField)
                    .frame(width: 200)
                    .multilineTextAlignment(.center)
                    .modifier(PrimaryLabel())
                    .keyboardType(.numbersAndPunctuation)
                    .textFieldStyle(OvalTextFieldStyle())
                    .submitLabel(.next)
            }
            .padding(.bottom)
            .padding(.leading,20)
            .padding(.trailing,20)
            
            HStack {
                Text("Rate:         ")
                    .modifier(PrimaryLabel())
                Spacer()
                TextField("rate", text: $rateTextField, onEditingChanged: { changed in
                    print("oneEdititng chaged: \(changed)")
                    if (changed == true) {
                        rateTextField = ""
                    }
                })
                    .focused($focusedField, equals: .rateTextField)
                    .frame(width: 200)
                    .multilineTextAlignment(.center)
                    .modifier(PrimaryLabel())
                    .keyboardType(.numbersAndPunctuation)
                    .textFieldStyle(OvalTextFieldStyle())
                    .submitLabel(.return)
            }
            .padding(.bottom)
            .padding(.leading,20)
            .padding(.trailing,20)
            
            
            HStack {
                Text("Time Left:      ")
                    .modifier(PrimaryLabel())
                Spacer()
                Text(timeText)
                    .frame(width: 200)
                    .multilineTextAlignment(.center)
                    .modifier(PrimaryLabel())
                    .keyboardType(.numbersAndPunctuation)
            }
            .padding(.leading,20)
            .padding(.trailing,20)
            .padding(.bottom)
            
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
                    countDown = 0
                    timerCounting = false
                    //self.timer.invalidate()
                    self.timerText = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
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
                    timeText = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
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
                    let time = secondsToHoursMinutesSeconds(seconds: total)
                    let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
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
                    if countDown <= 0 {
                        self.countDown = getTotalSecondsLeft()
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
                        if countDown >= 600 {
                            let minuteLeft = countDown - 599
                            print(countDown)
                            /*sendNotification(timeInterval: Double(minuteLeft), title: "10 Minutes Left", body: "HAMILTON: there is 10 minutes left", sound: "critalAlarm.wav") */
                            notificationManager.sendLocalNotification(timeInterval: Double(minuteLeft), title: "10 mins Left", body: "FREE FLOW there is 10 mins left", sound: "critalAlarm.wav")
                        }
                        if countDown >= 60 {
                            let tenseconds = countDown - 59
                            print(countDown)
                            notificationManager.sendLocalNotification(timeInterval: Double(tenseconds), title: "1 min Left", body: "FREE FLOW there is 1 mins left", sound: "critalAlarm.wav")
                        }
                        if countDown >= 2 {
                            let twoSeconds = countDown - 1
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
                        print(countDown)
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
            //.padding()
        }
        .onSubmit {
            switch focusedField {
            case .psiTextField:
                focusedField = .rateTextField
            default:
                print("you have submitted")
            }
        }
        .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text("Calculation needs to be greater than 0"), dismissButton: .default(Text("OK")))
            }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            print("app entered foreground")
            
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
            if (timerCounting == true && isInForeground == false) {
                // I am subrtracting 2 because when the conversion happens between foreground and background i think i lose a second
                countDown = countDown - (timePassedInBack - 2)
            }
            
            isInForeground = true
            /*print(countDown, "app is in foreground2")*/
        }
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
        }
        .onReceive(timer) { time in
            guard timerCounting else { return }
            print(countDown, "this is in timerCounter()")
            
            //countDown -= 1
            if (countDown > 0) {
                countDown -= 1
            }
            if (countDown <= 0) {
                //timer.invalidate()
                timerCounting = false
            }
            // if i want to add a message when it hits a certain amount of seconds i should make phone vibrate show notification
            let time = secondsToHoursMinutesSeconds(seconds: countDown)
            let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
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
