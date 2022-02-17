//
//  ShiftsViewModel.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 2/12/22.
//

import Foundation
import Firebase
// this is the day in which It lands on. SO I want to create an array of this so I can get multiple days
struct ShiftsMetaData: Identifiable {
    var id: String = ""
    var shift: [Shifts] = [Shifts]()
    var shiftDate: Date = Date()
}
class ShiftsViewModel: ObservableObject {
    // creating zero filled days but I am going to want to fill it up with task
    @Published var tempShifts = [ShiftsMetaData]()
    @Published var allShifts = [Shifts]()
    @Published var desend = [Shifts]()
    @Published var arrShift = [Shifts]()
    private var db = Firestore.firestore()
    
    func fetchAllShifts() {
        db.collection("shifts").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print(error)
                print("There was an error getting the shifts documents")
                return
            }
            self.allShifts = documents.map { (querySnapshot) -> Shifts in
                //let shiftId = data
                let data = querySnapshot.data()
                let shiftId = data["id"] as? String ?? ""
                let comment = data["comment"] as? String ?? ""
                let jobShifts = data["jobShifts"] as? [String: String] ?? [String: String]()
                print(data["jobShifts"])
            
                //var jobShifts = Dictionary = [String: String]()
                var shiftName = data["shiftName"] as? String ?? ""
                let startTime = (data["startTime"] as? Timestamp)?.dateValue() ?? Date()
                let endTime = (data["endTime"] as? Timestamp)?.dateValue() ?? Date()
                
               return Shifts(id: shiftId, comment: comment, jobShifts: jobShifts, shiftName: shiftName, startTime: startTime, endTime: endTime)
            }
        }
    }
    
    func fetchShiftMetaData() {
//        shifts.append(ShiftsMetaData(task: [
//            Task(title: "OM 1", time: Date(timeIntervalSince1970: 99999333)),
//            Task(title: "Dispatch", time: getDate5(date: "2022/01/09 14:12")!),
//        ], taskDate: getDate5(date: "2022/01/09 23:12")!))
        
        db.collection("shifts").order(by: "startTime", descending: true).getDocuments { (document, error) in
            guard let documents = document?.documents else {
                print("There was an error")
                print(error)
                return
            }
            var FirstDate = Date()
            var secondDate = Date()
            var isFirst = true
            
            
            
            self.desend = documents.map { (querySnapShot) -> Shifts in
                let data = querySnapShot.data()
                let shiftId = data["id"] as? String ?? ""
                let comment = data["comment"] as? String ?? ""
                let jobShifts = data["jobShifts"] as? [String: String] ?? [String: String]()
                print(data["jobShifts"])
            
                //var jobShifts = Dictionary = [String: String]()
                var shiftName = data["shiftName"] as? String ?? ""
                let startTime = (data["startTime"] as? Timestamp)?.dateValue() ?? Date()
                let endTime = (data["endTime"] as? Timestamp)?.dateValue() ?? Date()
                print(startTime)
                print(shiftName)
                
                print(self.allShifts.count)
                if isFirst == true {
                    FirstDate = startTime
                    secondDate = startTime
                    isFirst = false
                } else {
                    secondDate = startTime
                }
                self.arrShift.append(Shifts(id: shiftId, comment: comment, jobShifts: jobShifts, shiftName: shiftName, startTime: startTime, endTime: endTime))
                if self.isSameDay(date1: FirstDate, date2: secondDate) {
                    
                    print("the days MATCH")
                    //print(tempShifts.shift)
                } else {
                    //CalenderShifts.append(tempShifts)
                    
                    self.tempShifts.append(ShiftsMetaData(id: shiftId, shift: self.arrShift, shiftDate: FirstDate))
                    
                    
                        
                    
                    self.arrShift = [Shifts]()
                    FirstDate = secondDate
                    print("The days do not match")
                }
                print(self.tempShifts.count)
                print("TEMSHift")
                // save the first day
                // if the next day is the  same than store it on the same MetaData
                // once its not that Im going to append that to that main
                return Shifts(id: shiftId, comment: comment, jobShifts: jobShifts, shiftName: shiftName, startTime: startTime, endTime: endTime)
            }
        }
        
    }
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
}
