//
//  MainSideMenu.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 1/28/22.
//

import SwiftUI

struct MainSideMenu: View {
    @Binding var showMenu: Bool
    @State var isShowingLogIn = false
    //@ObservedObject private var viewModel = userViewModel()
    @ObservedObject var viewModel: userViewModel
    @ObservedObject var shiftViewModel = ShiftsViewModel()
    @State var isFirst = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 14) {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 65, height: 65)
                    
                Text(viewModel.currentUser.firstName)
                    .font(.title2.bold())
                    
                

//                Button("Text") {
//                    viewModel.fetchData()
//                }

                Text(viewModel.currentUser.Qualifications)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .onTapGesture {
                        print("hey")
                        //viewModel.fetchCurrentUser()
                    }
                
                HStack(spacing: 12) {
                    Button {
                        
                    } label: {
                        Label {
                            Text("Blank Data")
                        } icon: {
                            Text("189")
                                .fontWeight(.bold)
                        }
                    }
//                    Button {
//
//                    } label: {
//                        Label {
//                            Text("Following")
//                        } icon: {
//                            Text("1.2M")
//                                .fontWeight(.bold)
//                        }
//                    }
                }
                .foregroundColor(.primary)
                
                
                
            }
            
            .padding(.horizontal)
            .padding(.leading)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    // Tab Button
                    Group {
                        Divider()
                        TabButton(title: "Profile", image: "person.fill")
                        Divider()
                        TabButton(title: "Calendar", image: "calendar")
                        Divider()
                        TabButton(title: "Punch", image: "clock")
                        Divider()
                        TabButton(title: "timer", image: "timer")
                    }
                    if viewModel.currentUser.costCenter == "Admin" {
                        Divider()
                        TabButton(title: "New Employee", image: "logo.playstation")
                        Divider()
                        TabButton(title: "New Shift", image: "loupe")
                        TabButton(title: "All Shifts", image: "calendar")
                    }
                    
                    // this is how I can show data depending on the user
                    //if viewModel.currentUser.lastName != "Jimenez" {
                    Divider()
                        TabButton(title: "LogOut", image: "power")
                
                }
                .padding()
                .padding(.leading)
                .padding(.top, 35)
            }
        }
        .onAppear() {
            viewModel.fetchData()
            viewModel.fetchCurrentUser()
        }
        .padding(.top)
        .frame(maxWidth: .infinity, alignment: .leading)
        // Max Width
        .frame(width: getRect().width - 90)
        .frame(maxHeight: .infinity)
        .background(
            Color.primary
                .opacity(0.04)
                .ignoresSafeArea(.container, edges: .vertical)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .fullScreenCover(isPresented: $isShowingLogIn) {
            SignInView()
        }
        
    }
    @ViewBuilder
    func TabButton(title: String, image: String) -> some View {
        
        // For navigation...
        // Simply replace button with Navigation Links...
//        Button {
//
//        } label: {
//            HStack(spacing: 14) {
//                Image(systemName: image)
//                    .resizable()
//                    .renderingMode(.template)
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 22, height: 22)
//                Text(title)
//            }
//            .foregroundColor(.primary)
//            .frame(maxWidth: .infinity, alignment: .leading)
//        }
        if title == "LogOut" {
            Button {
                isShowingLogIn = true
            } label: {
                HStack(spacing: 14) {
                    Image(systemName: image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 22, height: 22)
                    Text(title)
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        } else {
            NavigationLink {
                // I would just put a whole view in here for that thing
                // if text == Calendar than I will go to this view
                
                if (title == "Calendar") {
                    CalendarView(shiftViewModel: shiftViewModel, viewModel: viewModel)
                } else if (title == "All Shifts") {
                    VStack {
                        Button("fetch all shifts") {
                            shiftViewModel.fetchAllShifts()
                            print(shiftViewModel.allShifts)
                            
                        }
                        Button("fetch shifts desc") {
                            
                            print(shiftViewModel.CalendarShifts)
                            
                            shiftViewModel.fetchShiftMetaData()
                            print(shiftViewModel.CalendarShifts)
                        }
                        List(shiftViewModel.CalendarShifts) { shift in
                            VStack {
                                
                                Text(shift.id)
//                                if shift.shift.count > 0 {
//                                    Text(shift.shift[0].shiftName)
//                                }
//
//                                if shift.shift.count > 1 {
//                                    Text(shift.shift[0].shiftName)
//                                    Text(shift.shift[1].shiftName)
//                                }
                                if shift.shift.count > 0 {
                                    Text(shift.shift[0].shiftName)
                                }
                                
                                
                                Text("\(shift.shiftDate)")
                            }
                        }
                        // I Found the issue I am just displaying the same thing over and over agian
                        List(shiftViewModel.allShifts) { shift in
                            VStack {
                              //  Text(shift.id)
                                //Text(shift.comment)
                                Text(shift.shiftName)
                                //Text("\(shift.jobShifts[0])")
                                //Text(shift.jobShifts[0].valu)
                                // so I am storing my information correctly just only when its time to display I am doing it wrong
                                
                                // I just need to create a 2D array its going to be to complicated to keep it this format
                                // the issue I am having it displaying the values of the dictionary.
                                ForEach(shift.jobShifts.sorted(by: <), id: \.key) { key, value in
                                    HStack {
                                        Text(key)
                                        Text(value)
                                    }
                                }
                                
                                
                                Text("\(shift.startTime)")
                                Text("\(shift.endTime)")
                            }
                        }
                    }
                } else if (title == "Profile") {
                    ProfileView(viewModel: viewModel)
                } else if (title == "New Shift") {
                    NewShiftView()
                        .navigationTitle(title)
                        .navigationBarTitleDisplayMode(.inline)
                }
                
                else if (title == "timer") {
                    // I can make it always true because I created this before as my home view I will need to fix it to remove this
                    ContentView(isLoggedIn: .constant(true))
                    // I think this might make my logic a bit easier all I have to do is view will appear and view will disappear and I just have to keep track of that
                    // I can also make them into seperate views So I dont have to worry about the things now saving or calling stuff.
                } else if (title == "New Employee") {
                    UserInfoView()
                        .navigationTitle("New Employee")
                        .navigationBarTitleDisplayMode(.inline)
                }
                else  {
                    Text(title)
                        .navigationTitle(title)
                }
                
                    
            } label: {
                HStack(spacing: 14) {
                    Image(systemName: image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 22, height: 22)
                    Text(title)
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        
    }
    
}

//struct MainSideMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        MainSideMenu(showMenu: .constant(true), viewModel: userViewMo)
//            
//    }
//}

extension View {
    func getRect()->CGRect {
        return UIScreen.main.bounds
    }
}
