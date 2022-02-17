//
//  Task.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 1/29/22.
//

import Foundation
import SwiftUI

// Task Model and Sample Tasks...
// Array of Tasks...


struct Employee: Identifiable {
    var id = UUID().uuidString
    
    var name: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var job: String = ""
}
struct Task: Identifiable {
    var id = UUID().uuidString
    var title: String = ""
    var time: Date = Date()
    var emp: [Employee] = [Employee]()
    var detail: String = ""
    
}


func getDate5(date: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
    //dateFormatter.timeZone = TimeZone.current
    //dateFormatter.locale = Locale.current
    return dateFormatter.date(from: date) // replace Date String
}
// Total Task Meta View...
struct TaskMetaData: Identifiable {
    var id = UUID().uuidString
    var task: [Task]
    var taskDate: Date
    
    // so the task will be my shifts
    // and the taskDate will be shared for the stardate so I can have multiple on that one day
}

// sample Date for Testing
func getSampleDate(offset: Int) -> Date {
    let calender = Calendar.current
    let date = calender.date(byAdding: .day, value: offset, to: Date())
    return date ?? Date()
}
var Pruitt: Employee = {
    Employee(name: "Pruitt, S", job: "Vaccinator")
}()
var Valdez: Employee {
    Employee(name: "Valdez, R", job: "Vaccinator")
}
var Williams: Employee {
    Employee(name: "Williams, J", job: "Vaccinator")
}
var Anderson: Employee {
    Employee(name: "Anderson, A", job: "Site Lead")
}

var des = "Puentes Cure Resource Fair / Mater Academy / 3900 E. Bonanza Rd Las Vegas Nv 89110"
// Sample task...
var tasks: [TaskMetaData] = [
    TaskMetaData(task: [
        Task(title: "OM 1", time: Date(timeIntervalSince1970: 99999333)),
        Task(title: "Dispatch", time: getDate5(date: "2022/01/09 14:12")!),
        Task(title: "AIR1"),
        Task(title: "Decatur COVID Tester", detail: "Day 3 of Training"),
        Task(title: "Venetian Testing"),
        Task(title: "MVS - Southern Nevada", time: getDate5(date: "2022/01/09 23:12")!, emp: [Pruitt, Valdez, Williams, Anderson], detail: des),
        Task(title: "Bookkeeper"),
        Task(title: "SNHD Strike Team")
    ], taskDate: getDate5(date: "2022/01/09 23:12")!),
    TaskMetaData(task: [
        Task(title: "Talk to the best")
    ], taskDate: getSampleDate(offset: -3)),
    TaskMetaData(task: [
        Task(title: "Meeting with Tim CooK")
    ], taskDate: getSampleDate(offset: -8)),
    TaskMetaData(task: [
        Task(title: "Next Version of Swiftui")
    ], taskDate: getSampleDate(offset: 10)),
    TaskMetaData(task: [
        Task(title: "Nothing much Workout")
    ], taskDate: getSampleDate(offset: -22)),
    TaskMetaData(task: [
        Task(title: "Meetdsfdsfsf")
    ], taskDate: getSampleDate(offset: 15)),
    TaskMetaData(task: [
        Task(title: "Meeting with Tim CooK")
    ], taskDate: getSampleDate(offset: -20)),
]


