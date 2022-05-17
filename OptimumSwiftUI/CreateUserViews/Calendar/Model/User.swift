//
//  User.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 2/1/22.
//

import Foundation

struct User: Identifiable {
    // I think I shouldnt set them equally to empty since those are things all users need I cant have one without it
    var id: String = ""
    var lastName: String = ""
    var firstName: String = ""
    var dateOfBirth: Date = Date()
    var status: String = "Active"
    var cellPhoneService: String = ""
    var phoneNumber: String = ""
    var EmergencyContact: String = ""
    var EmergencyPhoneNumber: String = ""
    var EmailAddress: String = ""
    var hireDate: Date = Date()
    var costCenter: String = ""
    var PayRate: String = ""
    var payType: String = ""
    var Qualifications: String = ""
}
