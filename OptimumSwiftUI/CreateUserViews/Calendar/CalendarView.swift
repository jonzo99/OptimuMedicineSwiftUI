//
//  CalendarView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 1/29/22.
//

import SwiftUI

struct CalendarView: View {
    @State var details: Shifts = Shifts()
    @State var currentDate: Date = Date()
    @State private var mode: Int = 0
    @ObservedObject var shiftViewModel: ShiftsViewModel
    @ObservedObject var viewModel: userViewModel
    var body: some View {
        //NavigationView {
            
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                // Custom date picker..
                CustomDatePicker(currentDate: $currentDate, details: $details, shiftViewModel: shiftViewModel, userViewModel: viewModel)
                    .onAppear(perform: {
                        shiftViewModel.fetchShiftMetaData()
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
    
        //.navigationBarTitleDisplayMode(.inline,)
       // }
        // Safe Area View...
//        .safeAreaInset(edge: .bottom) {
//            HStack {
//                Button {
//
//                } label: {
//                    Text("Add Task")
//                        .fontWeight(.bold)
//                        .padding(.vertical)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.orange, in: Capsule())
//                }
//
//                Button {
//
//                } label: {
//                    Text("Add Remainder")
//                        .fontWeight(.bold)
//                        .padding(.vertical)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.purple, in: Capsule())
//                }
//            }
//            .padding(.horizontal)
//            .padding(.top,10)
//            .foregroundColor(.white)
//            .background(.ultraThinMaterial)
//        }
    }
}
//
//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        //CalendarView(shiftViewModel: ShiftsViewModel)
//    }
//}
