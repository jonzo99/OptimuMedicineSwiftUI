//
//  CustomDatePicker.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 1/29/22.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var currentDate: Date
    // Month update on arrow button clicks...
    
    @State var currentMonth: Int = 0
    @State var showDetailView: Bool = false
    @Binding var details: Shifts
    @ObservedObject var shiftViewModel: ShiftsViewModel
    @ObservedObject var userViewModel: userViewModel
    func dateToHHmm(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    @State var count = 0
    @State private var mode: Int = 0
    var body: some View {

            
        
        VStack(spacing: 35) {
            // Days...
            let days: [String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(extraData()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text(extraData()[1])
                        .font(.title.bold())
                }
                
                Spacer(minLength: 0)
                
                Button {
                    withAnimation{
                        currentMonth -= 1
                    }
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                Button {
                    withAnimation{
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
                
                
            }
            .padding(.horizontal)
            // Day View...
            
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Dates....
            // Lazy Grid..
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()) { value in
                    CardView(value: value)
                        .background(
//                        Capsule()
//                            .fill(Color.pink)
//                            .padding(.horizontal, 8)
//                            .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                            Color.red
                                .cornerRadius(8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 0.5 : 0)
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }
            VStack(spacing: 15) {
                Text("Tasks")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom,10)
                
                if let task = shiftViewModel.CalendarShifts.first(where: { task in
                    return isSameDay(date1: task.shiftDate, date2: currentDate)
                }) {
                    ForEach(task.shift) { task in
                       
                        VStack(alignment: .leading, spacing: 10) {
                            
                            // For Custom Timing...
                            //Text(task.time.addingTimeInterval(CGFloat.random(in: 0...5000)), style: .time)
                            //Text(task.startTime)
                            //Text("\(task.time)")
                            HStack {
                                Text(task.shiftName)
                                    .font(.title2.bold())
                                Spacer()
                                Text(dateToHHmm(date: task.startTime))
                                Text(" - ")
                                Text(dateToHHmm(date: task.endTime))
                                
                            }
                            
                            
                        }
                        
                        .onTapGesture {
                            print("you have clicked on ", task)
                            details = task
//                            let emp = task.emp
//                            for emp in emp {
//                                print(emp.name)
//                                print(emp.job)
//                            }
                            showDetailView = true
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(task.jobShifts.keys.contains("0 empty") ? Color.green.cornerRadius(10) : Color.gray.opacity(0.5).cornerRadius(10))
                        
                        
                    }
                } else {
                    Text("No Task Found")
                }
            }
            .padding()
        
        }
            
        .fullScreenCover(isPresented: $showDetailView) {
            DetailView(details: $details, viewModel: userViewModel)
        }
        .onChange(of: currentMonth) { newValue in
            // Updating Month...
            currentDate = getCurrentMonth()
        }
    }
    
    
    @ViewBuilder
    func CardView(value: DateValue)->some View {
        var circleColor = Color.green
        VStack {
            if value.day != -1 {
                if let task = shiftViewModel.CalendarShifts.first(where: { task in
                    return isSameDay(date1: task.shiftDate, date2: value.date)
                }) {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: task.shiftDate, date2: currentDate) ? .white : .black)
                        .frame(maxWidth:.infinity)
                    
                    Spacer()
                    HStack {
                        
                        ForEach(task.shift) { i in
//                            Circle()
//                                .fill(isSameDay(date1: task.shiftDate, date2: currentDate) ? .white : .pink)
//                                .frame(width: 8, height: 8)
                            Circle()
                                .fill(ColorIndicator.getColorForShift(shiftName: i.shiftName))
                                .frame(width: 8, height: 8)
                        }
                        
//                        Circle()
//                            .fill(isSameDay(date1: task.shiftDate, date2: currentDate) ? circleColor : circleColor)
//                            .frame(width: 8, height: 8)
//                        Circle()
//                            .fill(isSameDay(date1: task.shiftDate, date2: currentDate) ? .green : .green)
//                            .frame(width: 8, height: 8)
                    }
                } else {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .black)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
        
    }
    
    
    
    // checking dates...
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    // extrating Year And Month For display...
    func extraData()->[String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        // Getting current Month Date....
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate()->[DateValue]{
        let calendar = Calendar.current
        // Getting current Month Date....
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            // getting day...
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        // adding offset days to get exaact week day...
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
}



// Extending Date to get Current Month Dates...
extension Date {
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        // getting start Date...
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        // getting date...
        return range.compactMap { day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

