//
//  CalendarViewForUser.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 3/19/22.
//

import SwiftUI

struct CalendarViewForUser: View {
    @State var details: Shifts = Shifts()
    @State var currentDate: Date = Date()
    @State private var mode: Int = 0
    @ObservedObject var shiftViewModel: ShiftsViewModel
    @ObservedObject var viewModel: userViewModel
    var body: some View {
        //NavigationView {
        ZStack {
            Color.gray.opacity(0.3)
                .ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Custom date picker..
                    CustomDatePicker(currentDate: $currentDate, details: $details, shifts: $shiftViewModel.userAvailableShifts, userViewModel: viewModel)
                        .onAppear(perform: {
                            shiftViewModel.fetchCurrentUsersShifts(qualification: "OM 1")
                        })
                }
                
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Color", selection: $mode) {
                        Text("All Available Jobs").tag(0)
                            .font(.title)
                        Text("Jobs For Me").tag(1)
                            .font(.title)
                    }
                    .foregroundColor(.gray)
                    .tint(Color.gray)
                    //                .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
    }
}
