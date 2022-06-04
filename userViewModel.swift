//
//  userViewModel.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 2/1/22.
//

import Foundation
import FirebaseFirestore
import Firebase

class userViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var currentUser = User(id: "", lastName: "")
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("There was no documents")
                return
            }
            self.users = documents.map { (querySnapshot) -> User in
                let data = querySnapshot.data()
                
                let lastName = data["lastName"] as? String ?? ""
                let userId = data["id"] as? String ?? ""
                let firstName = data["firstName"] as? String ?? ""
                let dob = (data["dateOfBirth"] as? Timestamp)?.dateValue() ?? Date()
                let status = data["status"] as? String ?? ""
                let cellPhoneService = data["cellPhoneService"] as? String ?? ""
                let phoneNumber = data["phoneNumber"] as? String ?? ""
                let emergencyContact = data["EmergencyContact"] as? String ?? ""
                let emergencyPhoneNumber = data["EmergencyPhoneNumber"] as? String ?? ""
                let email = data["EmailAddress"] as? String ?? ""
                let hireDate = (data["hireDate"] as? Timestamp)?.dateValue() ?? Date()
                let costCenter = data["costCenter"] as? String ?? ""
                let payRate = data["PayRate"] as? String ?? ""
                let payType = data["payType"] as? String ?? ""
                let qualifications = data["Qualifications"] as? String ?? ""
                
                return User(id: userId, lastName: lastName, firstName: firstName, dateOfBirth: dob, status: status, cellPhoneService: cellPhoneService, phoneNumber: phoneNumber, EmergencyContact: emergencyContact, EmergencyPhoneNumber: emergencyPhoneNumber, EmailAddress: email, hireDate: hireDate, costCenter: costCenter, PayRate: payRate, payType: payType, Qualifications: qualifications)
            }
            
        }
        
    }
    func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //print(uid)
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Faild", error)
            }
            
            if let data = snapshot?.data() {
                let lastName = data["lastName"] as? String ?? ""
                let userId = data["id"] as? String ?? ""
                let firstName = data["firstName"] as? String ?? ""
                let dob = (data["dateOfBirth"] as? Timestamp)?.dateValue() ?? Date()
                let status = data["status"] as? String ?? ""
                let cellPhoneService = data["cellPhoneService"] as? String ?? ""
                let phoneNumber = data["phoneNumber"] as? String ?? ""
                let emergencyContact = data["EmergencyContact"] as? String ?? ""
                let emergencyPhoneNumber = data["EmergencyPhoneNumber"] as? String ?? ""
                let email = data["EmailAddress"] as? String ?? ""
                let hireDate = (data["hireDate"] as? Timestamp)?.dateValue() ?? Date()
                let costCenter = data["costCenter"] as? String ?? ""
                let payRate = data["PayRate"] as? String ?? ""
                let payType = data["payType"] as? String ?? ""
                let qualifications = data["Qualifications"] as? String ?? ""
                self.currentUser = User(id: userId, lastName: lastName, firstName: firstName, dateOfBirth: dob, status: status, cellPhoneService: cellPhoneService, phoneNumber: phoneNumber, EmergencyContact: emergencyContact, EmergencyPhoneNumber: emergencyPhoneNumber, EmailAddress: email, hireDate: hireDate, costCenter: costCenter, PayRate: payRate, payType: payType, Qualifications: qualifications)
            } else {
                print("There was an issue getting the current user")
            }
            
        }
        
    }
}
