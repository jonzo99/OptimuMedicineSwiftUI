//
//  ShiftsViewModel.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 2/12/22.
//

import Foundation
import Firebase
import FirebaseFirestore


class ShiftsViewModel: ObservableObject {
    // creating zero filled days but I am going to want to fill it up with task
    @Published var CalendarShifts = [ShiftsMetaData]()
    
    //var shiftsArr = [Shifts]()
    @Published var allShifts = [Shifts]()
    @Published var userAvailableShifts = [ShiftsMetaData]()
    //@Published var arrShift = [Shifts]()
    private var db = Firestore.firestore()
    // I dont think I needed to sort them by the day becuase my calendar would do that for me but I dont know Ill leave it how it is now
    // if somethnig comees up than I will know I messed it up
    func fetchCurrentUsersShifts(qualification: String) {
        db.collection("shifts").whereField("shiftName", isEqualTo: "OM 1").getDocuments() { [self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print(error)
                print("There was an error getting the shifts documents")
                return
            }
            userAvailableShifts = [ShiftsMetaData]()
            var tempshiftMeta = ShiftsMetaData()
            var shiftsArr = [Shifts]()
            var FirstDate = Date()
            var isFirst = true
            allShifts = documents.map { (querySnapshot) -> Shifts in
                //let shiftId = data
                
    
                let data = querySnapshot.data()
                let shiftId = data["id"] as? String ?? ""
                let comment = data["comment"] as? String ?? ""
                let jobShifts = data["jobShifts"] as? [String: String] ?? [String: String]()
                let shiftName = data["shiftName"] as? String ?? ""
                let startTime = (data["startTime"] as? Timestamp)?.dateValue() ?? Date()
                let endTime = (data["endTime"] as? Timestamp)?.dateValue() ?? Date()
                
                
                
                if isFirst == true {
                    FirstDate = startTime
                    isFirst = false
                }
               
                let tempShifts = Shifts(id: shiftId, comment: comment, jobShifts: jobShifts, shiftName: shiftName, startTime: startTime, endTime: endTime)
                
                if self.isSameDay(date1: FirstDate, date2: startTime) {
                    print("the days MATCH")
                    
                } else {
                    let idd = UUID().uuidString
                    tempshiftMeta = ShiftsMetaData(id: idd, shift: shiftsArr, shiftDate: FirstDate)
//                    if shiftName == "OM 1" {
//                        userAvailableShifts.append(tempshiftMeta)
//                    }
                    userAvailableShifts.append(tempshiftMeta)
                    shiftsArr.removeAll()
                    print("The days do not match")
                }
                shiftsArr.append(tempShifts)
                FirstDate = startTime
                return Shifts(id: shiftId, comment: comment, jobShifts: jobShifts, shiftName: shiftName, startTime: startTime, endTime: endTime)
            }
            if shiftsArr.isEmpty {
                // dont add anything but if its not empty
            } else {
                userAvailableShifts.append(ShiftsMetaData(id: UUID().uuidString, shift: shiftsArr, shiftDate: shiftsArr[0].startTime))
            }
            
            
        }
    }
    func fetchShiftMetaData() {
//        shifts.append(ShiftsMetaData(task: [
//            Task(title: "OM 1", time: Date(timeIntervalSince1970: 99999333)),
//            Task(title: "Dispatch", time: getDate5(date: "2022/01/09 14:12")!),
//        ], taskDate: getDate5(date: "2022/01/09 23:12")!))
        
        db.collection("shifts").order(by: "startTime", descending: true).getDocuments { [self] (document, error) in
            guard let documents = document?.documents else {
                print("There was an error")
                print(error)
                return
            }
            CalendarShifts = [ShiftsMetaData]()
            var FirstDate = Date()
            var isFirst = true
            var tempshiftMeta = ShiftsMetaData()
            var shiftsArr = [Shifts]()
            //
            
            allShifts = documents.map { (querySnapShot) -> Shifts in
                let data = querySnapShot.data()
                let shiftId = data["id"] as? String ?? ""
                let comment = data["comment"] as? String ?? ""
                let jobShifts = data["jobShifts"] as? [String: String] ?? [String: String]()
                let shiftName = data["shiftName"] as? String ?? ""
                let startTime = (data["startTime"] as? Timestamp)?.dateValue() ?? Date()
                let endTime = (data["endTime"] as? Timestamp)?.dateValue() ?? Date()
                print(startTime)
                print(shiftName)
                
                if isFirst == true {
                    FirstDate = startTime
                    isFirst = false
                }
               
                let tempShifts = Shifts(id: shiftId, comment: comment, jobShifts: jobShifts, shiftName: shiftName, startTime: startTime, endTime: endTime)
                
                if self.isSameDay(date1: FirstDate, date2: startTime) {
                    print("the days MATCH")
                    
                } else {
                    let idd = UUID().uuidString
                    tempshiftMeta = ShiftsMetaData(id: idd, shift: shiftsArr, shiftDate: FirstDate)
//                    if shiftName == "OM 1" {
//                        userAvailableShifts.append(tempshiftMeta)
//                    }
                    CalendarShifts.append(tempshiftMeta)
                    shiftsArr.removeAll()
                    print("The days do not match")
                }
                shiftsArr.append(tempShifts)
                FirstDate = startTime
                return Shifts(id: shiftId, comment: comment, jobShifts: jobShifts, shiftName: shiftName, startTime: startTime, endTime: endTime)
            }
            if shiftsArr.isEmpty {
                // dont add anything but if its not empty
            } else {
                CalendarShifts.append(ShiftsMetaData(id: UUID().uuidString, shift: shiftsArr, shiftDate: shiftsArr[0].startTime))
            }
            
        }
        
    }
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
}
