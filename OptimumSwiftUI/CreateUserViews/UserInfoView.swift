//
//  UserInfoView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 1/22/22.
//

import SwiftUI
import iPhoneNumberField
import FirebaseFirestore
import FirebaseAuth
//import Foundation
struct UserInfoView: View {
    // I set the values to none because it allows the user to actually set the value
    @State var newUser = User(costCenter: "None", payType: "Hourly", Qualifications: "None")
    @State private var password = "12345678"
    let db = Firestore.firestore()
    
    // Professional Profile
    @State private var isEditing = false
    @State private var showAlert = false
    private let validation = ValidationService()
    @State private var errorMessage = ValidationError.invalidValue
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        List {
            Group {
                newUserTextField(isEditing: isEditing, value: $newUser.id, title: "Employee Id", imageString: "number")
                
                newUserTextField(isEditing: isEditing, value: $newUser.firstName, title: "First Name", imageString: "")
                
                newUserTextField(isEditing: isEditing, value: $newUser.lastName, title: "Last Name", imageString: "")
                HStack {
                    DatePicker(selection: $newUser.dateOfBirth, in: ...Date(), displayedComponents: [.date]) {
                        Text("DOB:")
                            .fontWeight(.semibold)
                    }
                    
                }
                HStack {
                    Text("Status:")
                        .fontWeight(.semibold)
                    Picker("Status", selection: $newUser.status) {
                        Text("Active").tag("Active")
                        Text("Inactive").tag("InActive")
                    }.pickerStyle(SegmentedPickerStyle())
                        .colorMultiply(newUser.status == "Active" ? Color.green : Color.red)
                    
                }
                
                HStack {
                    Text("Cell Phone Serice:")
                        .fontWeight(.semibold)
                    Spacer()
                    Picker("Select Phone Service", selection: $newUser.cellPhoneService) {
                        ForEach(Utilities.cellPhoneServices, id: \.self) {
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
                        iPhoneNumberField("(000) 000-0000", text: $newUser.phoneNumber)
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
            
            newUserTextField(isEditing: isEditing, value: $newUser.EmergencyContact, title: "Emergency Contact", imageString: "person.crop.circle.badge.exclamationmark")
            
            VStack(alignment: .leading, spacing: 2){
                Text("Emergency Phone Number")
                    .fontWeight(.semibold)
                HStack {
                    Image(systemName: "phone")
                    iPhoneNumberField("(000) 000-0000", text: $newUser.EmergencyPhoneNumber)
                }
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(isEditing ? Color.blue.opacity(0.4) : Color.black))
            }
            newUserTextField(isEditing: isEditing, value: $newUser.EmailAddress, title: "Email Address", imageString: "envelope")
            HStack {
                Spacer()
                Text("Professional Profile")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            HStack {
                DatePicker(selection: $newUser.hireDate, displayedComponents: [.date]) {
                    Text("Hire Date:")
                        .fontWeight(.semibold)
                }
            }
            HStack {
                Text("Cost Center:")
                    .fontWeight(.semibold)
                Spacer()
                Picker("CostCenter", selection: $newUser.costCenter) {
                    // I dont need to be using a dictionary here.
                    // I could just use the array but make sure to test that everyting is working
                    ForEach(Utilities.costCenterDictionary.sorted(by: <), id: \.value) { key, value in
                        Text("\(key)")
                    }
                }
                .pickerStyle(MenuPickerStyle())
                Spacer()
            }
            newUserTextField(isEditing: isEditing, value: $newUser.PayRate, title: "Pay Rate", imageString: "dollarsign.square.fill")
            HStack {
                Text("Pay Type:")
                    .fontWeight(.semibold)
                Picker("Pay Type", selection: $newUser.payType) {
                    Text("Hourly").tag("Hourly")
                    Text("Salary").tag("Salary")
                    
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            HStack {
                Text("Qualifications")
                    .fontWeight(.semibold)
                Spacer()
                Picker("Qualifications", selection: $newUser.Qualifications) {
                    
                    ForEach(Utilities.qualificationsDictionary.sorted(by: <), id: \.value) { key, value in
                        Text("\(key)").tag(value)
                    }
                    
                    
                }
                .pickerStyle(MenuPickerStyle())
                Spacer()
            }
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Error"), message: Text("\(errorMessage.localizedDescription)"), primaryButton: .default(Text("Cancel")) {
            }, secondaryButton: .cancel())
        })
        
        
        .toolbar {
            ToolbarItem {
                saveButton
            }
        }
    }
    
    var saveButton: some View {
        Button("Save") {
            saveAction()
        }
        .foregroundColor(.blue)
    }
    
    func saveAction() {
        do {
            let email  = try validation.validateUsername(newUser.EmailAddress)
            let pass = try validation.validatePassword(newUser.firstName)
        } catch {
            errorMessage = error as! ValidationError
            showAlert = true
            return
        }
        
        Auth.auth().createUser(withEmail: newUser.EmailAddress, password: password) { authResult, error in
            
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let uid = authResult?.user.uid {
                    let newUser = ["id": uid,
                                   "lastName": newUser.lastName,
                                   "firstName": newUser.firstName,
                                   "dateOfBirth": newUser.dateOfBirth,
                                   "status": newUser.status,
                                   "cellPhoneService": newUser.cellPhoneService,
                                   "phoneNumber": newUser.phoneNumber,
                                   "EmergencyContact": newUser.EmergencyContact,
                                   "EmergencyPhoneNumber": newUser.EmergencyPhoneNumber,
                                   "EmailAddress": newUser.EmailAddress,
                                   "hireDate": newUser.hireDate,
                                   "costCenter": newUser.costCenter,
                                   "PayRate": newUser.PayRate,
                                   "payType": newUser.payType,
                                   "Qualifications": newUser.Qualifications] as [String : Any]
                    db.collection("users").document(uid).setData(newUser) { error in
                        if let err = error {
                            print("there was an error", err)
                        } else {
                            print("That user has been created for you")
                        }
                    }
                }
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
            .previewInterfaceOrientation(.portrait)
    }
}

struct newUserTextField: View {
    @State var isEditing: Bool
    @Binding var value: String
    var title: String
    var imageString: String
    var body: some View {
        VStack(alignment: .leading, spacing: 2){
            Text(title)
                .fontWeight(.semibold)
            HStack {
                Image(systemName: imageString)
                TextField(title, text: $value, onEditingChanged: { edit in
                    self.isEditing = edit
                })
                
            }
            //.padding()
            .padding(8)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(isEditing ? Color.blue.opacity(0.4) : Color.black))
        }
    }
}
