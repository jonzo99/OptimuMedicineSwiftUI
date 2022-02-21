//
//  Shifts.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 2/12/22.
//

import Foundation

struct Shifts: Identifiable, Hashable {
    // I think I shouldnt set them equally to empty since those are things all users need I cant have one without it
    var id: String = ""
    var comment: String = ""
    var jobShifts: Dictionary = [String: String]()
    var shiftName: String = ""
    var startTime: Date = Date()
    var endTime: Date = Date()
    // I am going to need a start time and an end time for this
    
}
