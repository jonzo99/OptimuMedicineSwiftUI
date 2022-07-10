//
//  HamiltonView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 10/9/21.
//
import SwiftUI
// every time I change a value I should do all the calculations
// to get the time. In order the user does not have to edit.


// I should only let the user to change the values when the timer is
// not counting down that is why they will have to press reset.

//@available(iOS 15.0, *)

// Here for the times i Need to create a viewModel

//View, ViewModel, Model


/*
 So HamiltonView and FreeFlow would be the View
 Create class thats like OxgenHelperViewModel
 
 */
struct HamiltonView: View {
    
    func getTotalSecondsLeft() -> Int {
        let numPsiTextField  = Double(psiTextField)  ?? 0
        let numRateTextField = Double(rateTextField) ?? 0
        let numVtTextField   = Double(vtTextField)   ?? 0
        let numFi02TextField = Double(fi02TextField) ?? 0
        
        let a = selectedTankSize * numPsiTextField
        let b = (numRateTextField * numVtTextField / 1000 * 1.1) + selectedPatient
        let c = (numFi02TextField - 20.9) / 79.1
        let totalTimeInSeconds = (1 / (b * c) * a) * 60
        
        return Int(round(totalTimeInSeconds))
    }
    
    @ObservedObject var notificationManager = LocalNotificationManager()
    @State var userNotificationCenter = UNUserNotificationCenter.current()
    @AppStorage("HamSelectedTankSize") var selectedTankSize = 0.16
    @AppStorage("HamSelectedSelectedPatient") var selectedPatient = 3.0
    @AppStorage("HampsiTextField") var psiTextField = ""
    @AppStorage("Hamfi02TextField") var fi02TextField = ""
    @AppStorage("HamrateTextField") var rateTextField = ""
    @AppStorage("HamvtTextField") var vtTextField   = ""
    @State private var stopStartText = "START"
    @State private var timerText = "00:00:00"
    @AppStorage("HamTimeLeft") var timeText = "00:00:00"
    
    @AppStorage("timerCountingHamilton") var timerCounting = false
    
    @State var hrs2 = 0
    @State var min2 = 0
    @State var sec2 = 0
    
    @AppStorage("totalTimeInSecHamilton") var totalTimeInSec = 0
    @AppStorage("totalTimeInSec2Hamilton") var totalTimeInSec2 = 0
    @AppStorage("timePassedInBackHamilton") var timePassedInBack = 0
    @State var first = false
    
    @AppStorage("isInForegroundHamilton") var isInForeground = true
    @State private var showAlert: Bool = false
    @FocusState private var focusedField: Field?
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @AppStorage("countDownHamilton") var countDown = 0
    @Environment(\.scenePhase) var scenePhase
    
    @State var isActive = true
    var body: some View {
        VStack(spacing: 8) {
            /*
            Text("Hamilton Oxygen Calculator")
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)*/
            Spacer()
            Group {
                
                HStack {
                    Text("Patient:   ")
                        .modifier(PrimaryLabel())
                    Spacer()
                    VStack {
                        Picker("patient", selection: $selectedPatient) {
                            Text("Adult/Ped").tag(3.0)
                            Text("Neonate").tag(4.0)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    .frame(width:200)
                    .multilineTextAlignment(.center)
                }
                .padding(.bottom)
                .padding(.leading,20)
                .padding(.trailing,20)
                
                TankSizePicker(selectedTankSize: $selectedTankSize)
                
                
                timerTextField(leftLabel: "Tank Psi: ", placeholder: "tank psi", text: $psiTextField, focused: $focusedField, nextFocusedValue: .psiTextField)
                
                timerTextField(leftLabel: "Fi02%:     ", placeholder: "fi02%", text: $fi02TextField, focused: $focusedField, nextFocusedValue: .fi02TextField)
                
                timerTextField(leftLabel: "Rate:         ", placeholder: "rate", text: $rateTextField, focused: $focusedField, nextFocusedValue: .rateTextField)
                
                timerTextField(leftLabel: "Vt (ml):    ", placeholder: "Vt(ml)", text: $vtTextField, focused: $focusedField, nextFocusedValue: .vtTextField)
                
                
                CaluclatedTime(displayTimeText: $timeText)
            }
            //Spacer()
            Text(timerText)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .frame(alignment: .center)
            //Spacer()
            Spacer()
            HStack {
                
                Button(action: {
                    //self.countDown = getTotalSecondsLeft()
                    //print(UserDefaults.standard.integer(forKey: "countDowns"))
                    countDown = 0
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
                    psiTextField  = ""
                    fi02TextField = ""
                    rateTextField = ""
                    vtTextField   = ""
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
                    // I added this condition here because if the user has a value for countdown than when the user presses start it doesnt do what the calculted value is. so this allows the user to do another calcultion and not mess up the countdown. while also if the timer is not counting down
                    
                    
                    if (timerCounting == false) {
                        countDown = total
                    }
                    let time = OxegenTimeHelper.secondsToHoursMinutesSeconds(seconds: total)
                    let timeString = OxegenTimeHelper.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
                    timeText = timeString
                    //timeLabel.text = String(getTotalSecondsLeft())
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
                            //print(countDown)
                            //print()
                            /*sendNotification(timeInterval: Double(minuteLeft), title: "10 Minutes Left", body: "HAMILTON: there is 10 minutes left", sound: "critalAlarm.wav") */
                            notificationManager.sendLocalNotification(timeInterval: Double(minuteLeft), title: "10 mins Left", body: "HAMILTON there is 10 mins left", sound: "critalAlarm.wav")
                        }
                        if countDown >= 60 {
                            print("I went throud the 60 sec loop")
                            let tenseconds = countDown - 59
                            print(countDown)
                            notificationManager.sendLocalNotification(timeInterval: Double(tenseconds), title: "1 min Left", body: "HAMILTON there is 1 mins left", sound: "critalAlarm.wav")
                        }
                        
                        if countDown >= 2 {
                            let twoSeconds = countDown - 1
                            notificationManager.sendLocalNotification(timeInterval: Double(twoSeconds), title: "Timer is Done", body: "HAMILTON Timer is done", sound: "critalAlarm.wav")
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
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
               // print("Inactive")
                isActive = false
            } else if newPhase == .active {
                // I added the isActive variable because when the user just has the app swiped up it takes off even more seconds than what the app is supposed to because the timer is still going down than it calculates tehe time the app is swiped up and removes that
               //print("active")
                //print(timerCounting)
                //print(isInForeground)
                if (timerCounting == true && isInForeground == false && isActive == true) {
                    // I am subrtracting 2 because when the conversion happens between foreground and background i think i lose a second
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
                    
                    //print(hrs2, min2, sec2)
                    
                    
                    // i might need an if statement to check if c
                    totalTimeInSec2 = (min2 * 60) + (hrs2 * 3600) + sec2
                    /*print(totalTimeInSec2, "   ", totalTimeInSec)
                     print(first, "    ", timerCounting) */
                    if (first == true && timerCounting == true) {
                        first = false
                    }
                    timePassedInBack = (totalTimeInSec2 - totalTimeInSec)
                    countDown = countDown - (timePassedInBack - 1)
                   // print("DOES THIS CALCULATION HAPPEN HERE")
                }
                isActive = true
                
            } else if newPhase == .background {
                //print("Background")

            }
            
            //print(newPhase)
        }
        .onSubmit {
            switch focusedField {
            case .psiTextField:
                focusedField = .fi02TextField
            case .fi02TextField:
                focusedField = .rateTextField
            case .rateTextField:
                focusedField = .vtTextField
            default:
                
                var total = getTotalSecondsLeft()
                if (total <= 0) {
                    showAlert = true
                    total = 0
                }
                // I added this condition here because if the user has a value for countdown than when the user presses start it doesnt do what the calculted value is. so this allows the user to do another calcultion and not mess up the countdown. while also if the timer is not counting down
                
                
                if (timerCounting == false) {
                    countDown = total
                }
                let time = OxegenTimeHelper.secondsToHoursMinutesSeconds(seconds: total)
                let timeString = OxegenTimeHelper.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
                timeText = timeString
            }
        }
        .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text("Calculation needs to be greater than 0"), dismissButton: .default(Text("OK")))
            }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
           // print("APP HAS ENTERED FOREGROUNG")
            
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
                countDown = countDown - (timePassedInBack + 1)
            }
            
            isInForeground = true
            /*print(countDown, "app is in foreground2")*/
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            //self.timerCounting = false
            //print("APP ENTERED BACKGROUND")
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
            /*
             print(totalTimeInSec)
             print(hrs, min, sec) */
        }
        .onReceive(timer) { time in
            guard timerCounting else { return }
            
            
            //countDown -= 1
            if (countDown > 0) {
                countDown -= 1
            }
            if (countDown <= 0) {
                //timer.invalidate()
                timerCounting = false
            }
            // if i want to add a message when it hits a certain amount of seconds i should make phone vibrate show notification
            let time = OxegenTimeHelper.secondsToHoursMinutesSeconds(seconds: countDown)
            let timeString = OxegenTimeHelper.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
            timerText = timeString
        }
    }
}

struct HamiltonView_Previews: PreviewProvider {
    static var previews: some View {
        HamiltonView()
    }
}
