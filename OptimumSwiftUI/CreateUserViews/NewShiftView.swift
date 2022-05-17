//
//  NewShiftView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 2/9/22.
//
//Users/jonzojimenez/Desktop/OptimuMedicineSwiftUI/OptimumSwiftUI/SideMenuViewModel.swift
import SwiftUI
import FirebaseFirestore
import Combine
import EventKit
import EventKitUI
import Foundation
struct NewShiftView: View {
    
    @State private var newShift = Shifts(comment: "Make sure to show up to work on Time", shiftName: "OM 1")
    @State var endHourMin: String = "20:30"
    @State var startHourMin = "10:30"
    
    // start time enter by textfield
    // end time enter by textfield
    @State var selectedQualifcation = ["None"]
    @State var selectedAmount = [1]
    let eventStore = EKEventStore()
    @Environment(\.presentationMode) var presentationMode
    let db = Firestore.firestore()
    @State private var nextDay = false
    @State private var repeatingEvent = false
    // and than I can have duration but only as informational
    var body: some View {
        // this is what I can do I can let the
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 2){
                    HStack {
                        Text("Shift")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    
                    HStack {
                        HStack {
                            Menu {
                                ForEach(Utilities.masterShifts, id: \.self) { qual in
                                    Button(qual) {
                                        self.newShift.shiftName = qual
                                    }
                                }
                            } label: {
                                TextField("", text: $newShift.shiftName)
                            }
                        }
                        .blackBorder()
                    }
                }
                .padding()
                VStack(alignment: .leading, spacing: 2){
                    HStack {
                        Text("Qualification")
                            .fontWeight(.semibold)
                        Button("Add") {
                            selectedQualifcation.append("None")
                            selectedAmount.append(1)
                        }
                        Button("Remove") {
                            let i = selectedQualifcation.count
                            selectedQualifcation.removeLast()
                        }
                        Spacer()
                        Text("Number")
                            .fontWeight(.semibold)
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    ForEach(selectedQualifcation.indices, id: \.self) { index in
                        HStack {
                            HStack {
                                Menu {
                                    ForEach(Utilities.qulifications, id: \.self) { qual in
                                        Button(qual) {
                                            self.selectedQualifcation[index] = qual
                                        }
                                    }
                                } label: {
                                    TextField("None", text: $selectedQualifcation[index])
                                }
                                
                            }
                            .blackBorder()
                            HStack {
                                TextField("#", value: $selectedAmount[index], format: .number)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: getRect().width/4)
                            .background()
                            .blackBorder()
                            VStack {
                                upArrowButton(i: index)
                                Spacer()
                                downArrowButton(i: index)
                            }
                        }
                    }
                    
                    Toggle("Repeating Event", isOn: $repeatingEvent)
                        .padding(.top)
                }
                .padding(.horizontal)
                Divider()
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        DatePicker("", selection: $newShift.startTime, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.blue, lineWidth: 3)
                            )
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                Divider()
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("Date")
                            .fontWeight(.semibold)
                        Spacer()
                        Spacer()
                        Text("Start")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("End")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 4)
                    
                    HStack {
                        Toggle("Next Day", isOn: $nextDay)
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.green)
                            TextField("8:00", text: $startHourMin)
                        }
                        .blackBorder()
                        
                        Divider()
                            .foregroundColor(.red)
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.red)
                            TextField("8:00", text: $endHourMin)
                            
                            //.clipped()
                        }
                        .blackBorder()
                    }
                    .blackBorder()
                }
                .padding(.leading)
                .padding(.trailing)
                HStack {
                    Text("Comments")
                    Spacer()
                }
                .padding(.leading, 10)
                TextEditor(text: $newShift.comment)
                    .blackBorder()
                
                
                // bellow this I will show an information cell that only shows the start and end date
                //  with the hour and min also I will have a switch that says nextday that represents teh  next day
                
            }
        }
        .toolbar {
            ToolbarItem {
                Text("Save")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        print("you have pressed save")
                        SaveButtonPressed()
                    }
            }
        }
    }
    
    func upArrowButton(i: Int) -> some View {
        Button {
            print("he")
            selectedAmount[i] += 1
        } label: {
            Image(systemName: "chevron.up")
                .foregroundColor(.green)
                .font(Font.title3.weight(.bold))
        }
    }
    func downArrowButton(i: Int) -> some View {
        Button {
            selectedAmount[i] -= 1
            print("he")
        } label: {
            Image(systemName: "chevron.down")
                .foregroundColor(.red)
                .font(Font.title3.weight(.bold))
        }
    }
    
    func SaveButtonPressed() {
        
        var numberOfShifts = 0
        for j in 0..<selectedQualifcation.count {
            for i in 0..<selectedAmount[j] {
                newShift.jobShifts[("\(numberOfShifts) empty")] = selectedQualifcation[j]
                print(newShift.jobShifts)
                numberOfShifts += 1
            }
        }
        
        let startHour = startHourMin.components(separatedBy: ":")[0]
        let startMin = startHourMin.components(separatedBy: ":")[1]
        newShift.startTime = Calendar.current.date(bySettingHour: Int(startHour) ?? 0, minute: Int(startMin) ?? 0, second: 0, of: newShift.startTime)!
        
        let endHour = endHourMin.components(separatedBy: ":")[0]
        let endMin = endHourMin.components(separatedBy: ":")[1]
        newShift.endTime = Calendar.current.date(bySettingHour: Int(endHour) ?? 0, minute: Int(endMin) ?? 0, second: 0, of: newShift.startTime)!
        let uuid = NSUUID().uuidString
        if nextDay {
            newShift.endTime = Calendar.current.date(byAdding: .day, value: 1, to: newShift.endTime)!
        }
        
        // I would just need to create a for loop for
        // The date the user choose so lets say the choose up to april first
        
        // while the starting date >= april first
        // keep sending it and than adding a week to it
        
        // make a variable the so for like 30 times create a variable that just exits it
        // so I dont break the back end.
        
        // this would be better to do not set the ID when I create it
        // but when I retrive it I should get the document id: and set the id to
        let shift = ["comment": newShift.comment,
                        "shiftName": newShift.shiftName,
                        "startTime": newShift.startTime,
                        "endTime": newShift.endTime,
                        "id": uuid,
                        "jobShifts": newShift.jobShifts] as [String : Any]
        db.collection("shifts").addDocument(data: shift) { error in
            if let err = error {
                print("there was an error")
            } else {
                print("new shift has been created")
            }
        }
        
        presentationMode.wrappedValue.dismiss()
        
    }
}

struct NewShiftView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NewShiftView()
        }
    }
}

extension View {
  @ViewBuilder func applyTextColor(_ color: Color) -> some View {
    if UITraitCollection.current.userInterfaceStyle == .light {
      self.colorInvert().colorMultiply(color)
    } else {
      self.colorMultiply(color)
    }
  }
}
