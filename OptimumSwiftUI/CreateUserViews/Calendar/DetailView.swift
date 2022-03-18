//
//  DetailView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 1/29/22.
//

import SwiftUI
import UIKit
import Foundation
import Combine
import FirebaseFirestore
import EventKit
import EventKitUI
struct DetailView: View {
    @Binding var details: Shifts
    @Environment(\.presentationMode) var presentationMode
    @State var showAlert = false
    let db = Firestore.firestore()
    @State var selectedValue: String = ""
    @State var selectedKey: String = ""
    @ObservedObject var viewModel: userViewModel
    let eventStore = EKEventStore()
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.7)
                    .ignoresSafeArea()
                
                VStack {
                    Text(details.shiftName)
                        .font(.largeTitle.bold())
                        .border(Color.black)
                        .padding()
                    //Spacer()
                    HStack(spacing: 10) {
                        Text(dateFormatDDMMYY(date: details.startTime))
                            .font(.title2.bold())
                            .padding(.leading, 20)
                        Spacer()
                        Text(dateFormatHHMM(date: details.startTime))
                            .font(.title2.bold())
                        Text("-")
                            .font(.title2.bold())
                        Text(dateFormatHHMM(date: details.endTime))
                            .font(.title2.bold())
                        Spacer()
                    }
                    List {
                        HStack{
                            Text("Employee")
                            Spacer()
                            Text("Title")
                        }
                        .font(.title2.bold())
                        .padding(.horizontal)
                        ForEach(details.jobShifts.sorted(by: <), id: \.key) { key, value in
                            HStack {
                                Text(key)
                                    .font(.title3.bold())
                                Spacer()
                                    
                                Text(value)
                                    .font(.title3.bold())
    
                                
//                                if emp.job == "Site Lead" {
//                                    Image(systemName: "person.crop.circle.badge.exclamationmark").foregroundColor(.red).imageScale(.large)
//                                } else {
//                                    Image(systemName: "person.crop.circle.badge.checkmark").foregroundColor(.green).imageScale(.large)
//                                }
                            }
                            .padding(.horizontal)
                            .listRowBackground(key.contains("empty") ? Color.green.opacity(0.4) : Color.gray.opacity(0.4))
                            .onTapGesture {
                                showAlert = true
                                selectedKey = key
                                selectedValue = value
                            }
                        }
                        
                    }
                    //.padding()
                    //.listStyle(.bordered)
                    .listStyle(.automatic)
                    .listStyle(.inset)
                    //.background(.red)
                    //.listStyle(BorderedListStyle)
                    //.listStyle()
                    
                    .cornerRadius(15)
                    .border(Color.black, width: 1)
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 2)
                    
                    //.padding()
                    //.frame(width: .infinity, height: 200, alignment: .center)
                    
                
                    //.background(Color.red.ignoresSafeArea())
                    //.listStyle(.sidebar)
                    
                    //Spacer()
                    //Spacer()
                    Text(details.comment)
                    Spacer()
                    
                    
                }
            }
            .onAppear() {
                eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
                           DispatchQueue.main.async {
                               if (granted) && (error == nil) {
                                   let event = EKEvent(eventStore: self.eventStore)
                                   // this is where I would
                                   // pop up the view so that the user can customize how
                                   // they want the event to be
//                                   event.title = "Keynote Apple"
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
            .navigationBarTitle("Pick Up Shift", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Confirm"), message: Text("Do you want to accept this job"), primaryButton: .default(Text("Yes🚑")) {
                    print("Hello world")
                    db.collection("shifts").whereField("id", isEqualTo: details.id).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("there was an error\(err)")
                        } else {
                            
                            let document = querySnapshot?.documents.first
                            var dic = details.jobShifts
                            dic.removeValue(forKey: selectedKey)
                            // here is where I would get the first and last name of selected user
                            // than I will set the
                            //dic["currentUser"] = selected value
                            dic[viewModel.currentUser.firstName] = selectedValue
                            document?.reference.updateData([
                                "comment": "Practice1",
                                "jobShifts": dic
                            ])
                            details.jobShifts = dic
                            let event:EKEvent = EKEvent(eventStore: eventStore)
                            event.title = "\(details.shiftName) Shift For Optimum"
                            event.startDate = details.startTime
                            event.endDate = details.endTime
                            event.notes = "Make sure to be on work on time"
                            event.calendar = eventStore.defaultCalendarForNewEvents
                            
                            do {
                                try eventStore.save(event, span: .thisEvent)
                                
                            } catch let error as NSError {
                                print("failed to save event with error : \(error)")
                            }
                            print("Saved Event")
                        }
                    }
                }, secondaryButton: .cancel(Text("NO 😕")))
            })
            
        }
        //.tint(.green)
        //.foregroundColor(Color.green)
    }
    
    func dateFormatDDMMYY(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        //dateFormatter.timeZone = TimeZone.current
        //dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    func dateFormatHHMM(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        //dateFormatter.timeZone = TimeZone.current
        //dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(details: .constant(Shifts(id: "id343", comment: "Behindthe school", jobShifts: ["0 empty": "Nurse", "Jonzo": "Nurse", "2 empty": "Admin"], shiftName: "OM 1", startTime: Date(), endTime: Date().addingTimeInterval(60 * 120))), viewModel: userViewModel())
            .previewInterfaceOrientation(.portrait)
    }
}

