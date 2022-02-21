//
//  NewShiftView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 2/9/22.
//
//Users/jonzojimenez/Desktop/OptimuMedicineSwiftUI/OptimumSwiftUI/SideMenuViewModel.swift
import SwiftUI
import Firebase
import Combine
import EventKit
import EventKitUI
import Foundation
struct NewShiftView: View {
    @State var numberOfEmp = "0"
    @State var employeeName = "Jonzo"
    @State var Shifts = ["OM 1", "EAL 1", "Instructor", "EAL 2", "OM 2", "Dispatch", "Education", "AIR1", "COVID Tester", "PR Standby", "Douglas School", "Decatur COVID Tester", "Venetian Testing", "Impact Wrestling", "MVS", "Accounting1", "MVS - Southern Nevada", "MVS - Rural", "MVS - Reno Area", "DDWTD s3", "Travel", "Office Hours", "Carson City School Testi", "SNHD Homebound", "Bookkeeper", "SNHD Strike Team", "Office Administrator", "Elko County School Testi", "CG Testing"
    ]
    @State var selectedShift: String = "OM 1"
    @State var qualifications = [
        "None",
        "Admin",
        "AEMT",
        "AOC",
        "CCT Paramedic",
        "EMT",
        "GOC",
        "Nurse",
        "Paramedic",
        "CFRN",
        "CCRN",
        "CEN",
        "Instructor",
        "MD",
        "EMT Intern",
        "Paramedic Intern",
        "CCT Intern",
        "Dispatcher",
        "COVID Tester",
        "RT",
        "Vaccinator",
        "Site Lead",
        "PR",
        "Data Entry"
    ]
    @State var selectedCostCenter = "none"
    @State var costCenterDic = [
        "None None",
        "ADMINI - ADMIN",
        "EDUCAT - Education",
        "EDUCATION - EDUCATION",
        "FLTOPS - Flight Ops",
        "GROUND - GROUND",
        "STAFFI - Staffing",
        "SPECEV - Special Events",
        "MOBVAX - Mobile Vaccinations",
        "VENETI - Venetian",
        "SNHDVX - SNHD Vaccinations"
    ]
    
    @State var endTime = Date()
    @State var endHourMin: String = "20:30"
    // StartTime
    @State var StartTime = Date()
    @State var startHourMin = "10:30"
    
    @State var commentss = "dfdsfdsfdsfdsfsdfdsf"
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        //dateFormatter.timeZone = TimeZone.current
        //dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date) // replace Date String
    }
    // start time enter by textfield
    // end time enter by textfield
    @State var qualificationDic = [String: String]()
    @State var selectedQualifcation = ["None"]
    let eventStore = EKEventStore()
    
    let db = Firestore.firestore()
    // and than I can have duration but only as informational
    var body: some View {
        NavigationView {
            // this is what I can do I can let the
            ScrollView {
                VStack(alignment: .leading, spacing: 2){
                    HStack {
                        Text("Shift")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    
                    HStack {
                        HStack {
                            //TextField("Employee ID", text: $employeeName)
                            Menu {
                                ForEach(Shifts, id: \.self) { qual in
                                    Button(qual) {
                                        self.selectedShift = qual
                                    }
                                }
                            } label: {
                                TextField("", text: $selectedShift)
                            }
                            
                            
                        }
                        .padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
                    }
                }
                .padding()
                VStack(alignment: .leading, spacing: 2){
                    HStack {
                        Text("Qulification")
                            .fontWeight(.semibold)
                        Button("Add") {
                            selectedQualifcation.append("None")
                        }
                        Button("Remove") {
                            let i = selectedQualifcation.count
                            selectedQualifcation.removeLast()
                            qualificationDic.removeValue(forKey: "\(i) empty")
                        }
                        Spacer()
                        Text("Number")
                            .fontWeight(.semibold)
                            .padding(.trailing, 25)
                    }
                    ForEach(selectedQualifcation.indices, id: \.self) { index in
                        HStack {
                            HStack {
                                //TextField("Employee ID", text: $employeeName)
                                Menu {
                                    ForEach(qualifications, id: \.self) { qual in
                                        Button(qual) {
                                            self.selectedQualifcation[index] = qual
                                        }
                                    }
                                } label: {
                                    TextField("None", text: $selectedQualifcation[index])
                                }
                                
                            }
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
                            HStack {
                                //Image(systemName: "number")
                                TextField("#", text: $numberOfEmp)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: getRect().width/4)
                            .background(Color.red)
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
                        }
                    }
                }
                .padding()
                Divider()
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        //Text("")
                        //                        TextField("Employee ID", text: $employeeId, onEditingChanged: { edit in
                        //                            self.isEditing = edit
                        //                        })
                        
                        DatePicker("", selection: $StartTime, displayedComponents: [.date])
                        
                        //.datePickerStyle(.compact)
                            .datePickerStyle(.graphical)
                        //.colorMultiply(.red)
                        //.applyTextColor(.white)
                        //.datePickerStyle(.automatic)
                        //.datePickerStyle(.compact)
                        //.drawingGroup()
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
                        //Spacer()
                        Text("End")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 4)
                    
                    HStack {
                        Text("\(dateToString(date: StartTime))")
                        Spacer(minLength: 40)
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.green)
                            TextField("8:00", text: $startHourMin)
                            
                            //.clipped()
                        }
                        .padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
                        
                        Divider()
                            .foregroundColor(.red)
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.red)
                            TextField("8:00", text: $endHourMin)
                            
                            //.clipped()
                        }
                        .padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
                    }
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
                }
                .padding(.leading)
                .padding(.trailing)
                HStack {
                    Text("Comments")
                    Spacer()
                }
                .padding(.leading, 10)
                TextEditor(text: $commentss)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                
                Button("ADD Event to callendar") {
                    let event:EKEvent = EKEvent(eventStore: eventStore)
                          event.title = "New Event Has Been created to you calendar"
                          event.startDate = Date()
                    event.endDate = Date().addingTimeInterval(60*120)
                          event.notes = "This is a note"
                          event.calendar = eventStore.defaultCalendarForNewEvents
                    
                          do {
                              try eventStore.save(event, span: .thisEvent)

                          } catch let error as NSError {
                              print("failed to save event with error : \(error)")
                          }
                          print("Saved Event")
                    
                }
                // bellow this I will show an information cell that only shows the start and end date
                //  with the hour and min also I will have a switch that says nextday that represents teh  next day
                
            }
            .onAppear() {
                eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
                           DispatchQueue.main.async {
                               if (granted) && (error == nil) {
                                   let event = EKEvent(eventStore: self.eventStore)
                                   event.title = "Keynote Apple"
                                   print("you gave me access")
//                                   event.startDate = self.time
//                                   event.url = URL(string: "https://apple.com")
//                                   event.endDate = self.time
//                                   let eventController = EKEventEditViewController()
//                                   eventController.event = event
//                                   eventController.eventStore = self.eventStore
//                                   eventController.editViewDelegate = self
//                                   self.present(eventController, animated: true, completion: nil)
                                   
                               }
                           }
                       })
            }
            .toolbar {
                ToolbarItem {
                    Text("Save")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            print("you have pressed save")
                            print(qualifications)
                            
                            //qualificationDic.updateValue(selectedQualifcation[0], forKey: "empty + 1")
//                            selectedQualifcation.forEach {
//                                qualificationDic.updateValue("\($0) empty", forKey: selectedQualifcation[$0])
//                            }
                            // I just need to create a 2D array its going to be to complicated to keep it this format
                            
                            for i in 0..<selectedQualifcation.count {
                                qualificationDic.updateValue(selectedQualifcation[i], forKey: "\(i) empty")
                            }
                            
                            let startHour = startHourMin.components(separatedBy: ":")[0]
                            let startMin = startHourMin.components(separatedBy: ":")[1]
                            StartTime = Calendar.current.date(bySettingHour: Int(startHour) ?? 0, minute: Int(startMin) ?? 0, second: 0, of: StartTime)!
                            
                            let endHour = endHourMin.components(separatedBy: ":")[0]
                            let endMin = endHourMin.components(separatedBy: ":")[1]
                            endTime = Calendar.current.date(bySettingHour: Int(endHour) ?? 0, minute: Int(endMin) ?? 0, second: 0, of: StartTime)!
                            let uuid = NSUUID().uuidString
                            let newShift = ["comment": commentss,
                                           "shiftName": selectedShift,
                                           "startTime": StartTime,
                                            "endTime": endTime,
                                            "id": uuid,
                                           "jobShifts": qualificationDic] as [String : Any]
                            db.collection("shifts").addDocument(data: newShift) { error in
                                if let err = error {
                                    print("there was an error")
                                } else {
                                    print("new shift has been created")
                                }
                            }
//                            db.collection("users").document(uid).setData(newUser) { error in
//                                if let err = error {
//                                    print("there was an error", err)
//                                } else {
//                                    print("That user has been created for you")
//                                }
//                            }
                            
                        }
                }
            }
        }
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