//
//  Shifts.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 2/12/22.
//

import Foundation

struct Shifts: Identifiable, Hashable {
    var id: String = ""
    var comment: String = ""
    var jobShifts: Dictionary = [String: String]()
    var shiftName: String = ""
    var startTime: Date = Date()
    var endTime: Date = Date()
}
  

struct ShiftsMetaData: Identifiable {
    var id: String = ""
    var shift: [Shifts] = [Shifts]()
    var shiftDate: Date = Date()
}
