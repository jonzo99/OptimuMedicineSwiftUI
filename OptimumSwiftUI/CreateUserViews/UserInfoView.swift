//
//  UserInfoView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 1/22/22.
//

import SwiftUI
import iPhoneNumberField
import Firebase
//import Foundation
struct UserInfoView: View {
    
    // Employee Profile
    @State var employeeId = ""
    @State var status = "Active"
    @State var lastName = ""
    @State var firstName = ""
    @State var dob = Date()
    @State var cellPhone = ""
    @State var cellPhoneService = ""
    @State var emergencyContact = ""
    @State var emergencyPhone = ""
    @State var password = "12345678"
    @State var email = ""
    let db = Firestore.firestore()
    
    // Professional Profile
    @State var hireDate = Date()
    @State var costCenter = "None"
    @State var payRate = ""
    @State var payType = "Hourly"
    
    @State var costCenterDic = [
        "None": "None",
        "ADMINI - ADMIN": "Admin",
        "EDUCAT - Education": "Education",
        "EDUCATION - EDUCATION": "EDUCATION",
        "FLTOPS - Flight Ops": "FlightOps",
        "GROUND - GROUND": "Ground",
        "STAFFI - Staffing": "Staffing",
        "SPECEV - Special Events": "SpecialEvents",
        "MOBVAX - Mobile Vaccinations": "MobileVaccinations",
        "VENETI - Venetian": "Venetian",
        "SNHDVX - SNHD Vaccinations": "SNHDVaccinations"
    ]
    @State var qualifications = "None"
    @State var qualificationsDic = [
        "None": "None",
        "Admin": "Admin",
        "AEMT": "AEMT",
        "AOC": "AOC",
        "CCT Paramedic": "CCT Paramedic",
        "EMT": "EMT",
        "GOC": "GOC",
        "Nurse": "Nurse",
        "Paramedic": "Paramedic",
        "CFRN": "CFRN",
        "CCRN": "CCRN",
        "CEN": "CEN",
        "Instructor": "Instructor",
        "MD": "MD",
        "EMT Intern": "EMT Intern",
        "Paramedic Interm": "Paramedic Intern",
        "CCT Intern": "CCT Intern",
        "Dispatcher": "Dispatcher",
        "COVID Tester": "COVID Tester",
        "RT": "RT",
        "Vaccinator": "Vaccinator",
        "Site Lead": "Site Lead",
        "PR": "PR",
        "Data Entry": "Data Entry"
    ]
    
    var body: some View {
        NavigationView {
            
            VStack {
                List {
                    Group {
                        
                    
                    HStack {
                        Text("Emloyee ID:")
                        TextField("Emloyee Id", text: $employeeId)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack {
                        Text("First Name: ")
                        TextField("Emloyee Id", text: $firstName)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack {
                        Text("Last Time: ")
                        TextField("Last Name", text: $lastName)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        //Text("DOB:")
                        DatePicker(selection: $dob, in: ...Date(), displayedComponents: [.date]) {
                                        Text("DOB: ")
                        }
                    }
                    
                    HStack {
                        Text("Status:")
                        Picker("Status", selection: $status) {
                            Text("Active").tag("Active")
                            Text("Inactive").tag("InActive")
                            
                        }.pickerStyle(SegmentedPickerStyle())
                        
                    }
                    HStack {
                        Text("Cell Phone Serice:")
                        TextField("Cell Phone Service", text: $cellPhoneService)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    HStack {
                        Text("Phone Number")
                        iPhoneNumberField("(000) 000-0000", text: $cellPhone)
                            .flagHidden(true)
                            .flagSelectable(false)
                        //.font(UIFont(size: 30, weight: .light, design: .monospaced))
                            .maximumDigits(10)
                        //.foregroundColor(Color.pink)
                            .clearButtonMode(.whileEditing)
                        //.onClear { _ in isEditing.toggle() }
                            .accentColor(Color.orange)
                        //.padding()
                            //.background(Color.white)
                        //.cornerRadius(10)
                            .shadow(color: .black, radius: 10)
                        //.shadow(color: isEditing ? .lightGray : .white, radius: 10)
                        //.padding()
                        
                    }
                    }
                    HStack {
                        Text("Emergency Contact:")
                        TextField("Emergency Contact", text: $emergencyContact)
                            .textFieldStyle(.roundedBorder)
                        
                    }
                    HStack {
                        Text("Emergency Phone #: ")
                        iPhoneNumberField("(000) 000-0000", text: $emergencyPhone)
                            .maximumDigits(10)
                    }
                    HStack {
                        Text("Email Address:")
                        TextField("Email Address", text: $email)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack {
                        Spacer()
                        Text("Professional Profile")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    HStack {
                        DatePicker(selection: $dob, in: ...Date(), displayedComponents: [.date]) {
                                        Text("Hire Date: ")
                        }
                    }
                    HStack {
                        
                        Picker("CostCenter", selection: $costCenter) {
                            
                            ForEach(costCenterDic.sorted(by: <), id: \.value) { key, value in
                                Text("\(key)").tag(value)
                            }
                                  
                            
                        }
                        
                    }
                    
                    HStack {
                        Text("Pay Rate:")
                        TextField("Pay Rate", text: $payRate)
                            .textFieldStyle(.roundedBorder)
                    }
                    HStack {
                        Text("Pay Type:")
                        Picker("Pay Type", selection: $payType) {
                            Text("Hourly").tag("Hourly")
                            Text("Salary").tag("Salary")
                            
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    
                    HStack {
                        Picker("Qualifications", selection: $qualifications) {
                            
                            ForEach(qualificationsDic.sorted(by: <), id: \.value) { key, value in
                                Text("\(key)").tag(value)
                            }
                                  
                            
                        }
                    }
                }
               
                .listStyle(.grouped)
                
            }
            
            
            .toolbar {
                ToolbarItem {
                    Text("Save")
                        .onTapGesture {
                            let dateFormater = DateFormatter()
                            dateFormater.dateFormat = "yyyy-MM-dd"
                            print(dob)
                            var dat = Date()
                            print(status)
                            print(dob.formatted(as: "yyyy-MM-dd"))
                            var d = dob.formatted(as: "yyyy-MM-dd")
                            dat = dateFormater.date(from: d)!
                            print(dat)
                            var date = dob.formatted(date: .long, time: .complete)
                            print(date)
                            

                            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                                
                                if let e = error {
                                    print(e)
                                    print(e.localizedDescription)
                                } else {
                                    
                                    if let uid = authResult?.user.uid {
                                        db.collection("users").document(uid).setData(["id": uid, "lastName": "Jimenez"]) { error in
                                            if let err = error {
                                                print("there was an error", err)
                                            } else {
                                                print("That user has been created for you")
                                            }
                                        }
                                    }
                                    // I should store my dob as a date variable just in case I want to do some
//                                    let user = ["employeeId": 1002,
//                                                "status": "Active",
//                                                "firstName" : "jonzo",
//                                                "lastName": "Jimenez",
//                                                "dob": getDate5(date: "2001/01/01 14:12")!,
//                                                "cellPhone": "7026019438",
//                                                "cellPhoneService": "Tmobile",
//                                                "emergencyContact": "Mom",
//                                                "emergencyPhone": "7026446766",
//                                                "HireDate": "June 1 2021"
//                                    ] as [String : Any]
                                    // I should save the uuid because they said it makes it easier down the road
//                                    db.collection("users").addDocument(data: user) { error in
//                                        if let err = error {
//                                            print("there was an issue saving you information")
//                                            print(err)
//                                        } else {
//                                            print("successfully saved data.")
//                                            showContentView = true
//                                        }
//
//                                    }
                                
                                }
                                
                            }
                        }
                }
            }
            .tint(.red)
                .navigationTitle("New Employee")
                .navigationBarTitleDisplayMode(.inline)
        }
        
        
    
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}
