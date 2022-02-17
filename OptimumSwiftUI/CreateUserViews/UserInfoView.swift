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
    @State var cellPhoneService = "Service"
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
    @State var cellPhoneServiceCompanies = ["Service","AT&T", "Verizon", "T-Mobile", "Sprint"]
    @State var isEditing = false
    var body: some View {
        //NavigationView {
        
        // VStack {
        List {
            Group {
                VStack(alignment: .leading, spacing: 2){
                    Text("Employee Id")
                        .fontWeight(.semibold)
                    HStack {
                        Image(systemName: "number")
                        TextField("Employee ID", text: $employeeId, onEditingChanged: { edit in
                            self.isEditing = edit
                        })
                        
                    }
                    //.padding()
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(isEditing ? Color.blue.opacity(0.4) : Color.black))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("First Name")
                        .fontWeight(.semibold)
                    HStack {
                        TextField("First Name", text: $firstName)
                    }
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.black))
                }
                
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Last Time")
                        .fontWeight(.semibold)
                    HStack {
                        
                        TextField("Last Name", text: $lastName)
                            //.textFieldStyle(.roundedBorder)
                    }
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.black))
                }
                
               
                
                HStack {
                    //Text("DOB:")
                    DatePicker(selection: $dob, in: ...Date(), displayedComponents: [.date]) {
                        Text("DOB:")
                            .fontWeight(.semibold)
                    }
                    
                }
                
                HStack {
                    Text("Status:")
                        .fontWeight(.semibold)
                    Picker("Status", selection: $status) {
                        Text("Active").tag("Active")
                        Text("Inactive").tag("InActive")
                    }.pickerStyle(SegmentedPickerStyle())
                        .colorMultiply(status == "Active" ? Color.green : Color.red)
                    
                }
                
                HStack {
                    Text("Cell Phone Serice:")
                        .fontWeight(.semibold)
                    Spacer()
                    Picker("Select Phone Servi", selection: $cellPhoneService) {
                        ForEach(cellPhoneServiceCompanies, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Phone Number")
                        .fontWeight(.semibold)
                    HStack {
                        Image(systemName: "phone")
                        iPhoneNumberField("(000) 000-0000", text: $cellPhone)
                            .flagHidden(true)
                            .flagSelectable(false)
                            .maximumDigits(10)
                            .clearButtonMode(.whileEditing)
                            .accentColor(Color.orange)
                            .shadow(color: .black, radius: 10)
                            //.textFieldStyle(.roundedBorder)
                    }
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.black))
                }
            }
            
            VStack(alignment: .leading, spacing: 2){
                Text("Emergency Contact")
                    .fontWeight(.semibold)
                HStack {
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                    TextField("Emergency Contact", text: $emergencyContact, onEditingChanged: { edit in
                        self.isEditing = edit
                    })
                    
                }
                //.padding()
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(isEditing ? Color.blue.opacity(0.4) : Color.black))
            }
            
            VStack(alignment: .leading, spacing: 2){
                Text("Emergency Phone Number")
                    .fontWeight(.semibold)
                HStack {
                    Image(systemName: "phone")
                    iPhoneNumberField("(000) 000-0000", text: $emergencyPhone)
                    
                }
                //.padding()
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(isEditing ? Color.blue.opacity(0.4) : Color.black))
            }
            VStack(alignment: .leading, spacing: 2){
                Text("Email Address")
                    .fontWeight(.semibold)
                HStack {
                    Image(systemName: "envelope")
                    TextField("Email Address", text: $email)
                    
                }
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(isEditing ? Color.blue.opacity(0.4) : Color.black))
            }
            HStack {
                Spacer()
                Text("Professional Profile")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            HStack {
                DatePicker(selection: $hireDate, in: ...Date(), displayedComponents: [.date]) {
                    Text("Hire Date:")
                        .fontWeight(.semibold)
                }
            }
            HStack {
                Text("Cost Center:")
                    .fontWeight(.semibold)
                Spacer()
                Picker("CostCenter", selection: $costCenter) {
                    
                    ForEach(costCenterDic.sorted(by: <), id: \.value) { key, value in
                        Text("\(key)").tag(value)
                    }
                    
                    
                }
                .pickerStyle(MenuPickerStyle())
                Spacer()
            }
            VStack(alignment: .leading, spacing: 2){
                Text("Pay Rate")
                    .fontWeight(.semibold)
                HStack {
                    Image(systemName: "dollarsign.square.fill")
                        .foregroundColor(.green)
                    TextField("Pay Rate", text: $payRate)

                    
                }
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(isEditing ? Color.blue.opacity(0.4) : Color.black))
            }
            HStack {
                Text("Pay Type:")
                    .fontWeight(.semibold)
                Picker("Pay Type", selection: $payType) {
                    Text("Hourly").tag("Hourly")
                    Text("Salary").tag("Salary")
                    
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            HStack {
                Text("Qualifications")
                    .fontWeight(.semibold)
                Spacer()
                Picker("Qualifications", selection: $qualifications) {
                    
                    ForEach(qualificationsDic.sorted(by: <), id: \.value) { key, value in
                        Text("\(key)").tag(value)
                    }
                    
                    
                }
                .pickerStyle(MenuPickerStyle())
                Spacer()
            }
        }
        
        //.listStyle(.grouped)
        
        // }
        
        
        .toolbar {
            ToolbarItem {
                Text("Save")
                    .tint(.blue)
                    .foregroundColor(.blue)
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
                                    let newUser = ["id": uid,
                                                   "lastName": lastName,
                                                   "firstName": firstName,
                                                   "dateOfBirth": dob,
                                                   "status": status,
                                                   "cellPhoneService": cellPhoneService,
                                                   "phoneNumber": cellPhone,
                                                   "EmergencyContact": emergencyContact,
                                                   "EmergencyPhoneNumber": emergencyPhone,
                                                   "EmailAddress": email,
                                                   "hireDate": hireDate,
                                                   "costCenter": costCenter,
                                                   "PayRate": payRate,
                                                   "payType": payType,
                                                   "Qualifications": qualifications] as [String : Any]
                                    db.collection("users").document(uid).setData(newUser) { error in
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
                                
                                // }
                                
                            }
                        }
                    }
            }
            //            .tint(.red)
            //                .navigationTitle("New Employee")
            //                .navigationBarTitleDisplayMode(.inline)
        }
        
        
        
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
.previewInterfaceOrientation(.portrait)
    }
}
