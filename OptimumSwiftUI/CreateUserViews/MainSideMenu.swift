//
//  MainSideMenu.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 1/28/22.
//

import SwiftUI
import FirebaseFirestore
import Firebase
import Combine
struct MainSideMenu: View {
    @Binding var showMenu: Bool
    @State var isShowingLogIn = false
    //@ObservedObject private var viewModel = userViewModel()
    //@Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: userViewModel
    @ObservedObject var shiftViewModel: ShiftsViewModel
    @State var isFirst = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            profileHeaderView
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Divider()
                    TabButton(title: "Profile", image: "person.fill")
                    if viewModel.currentUser.costCenter == "Admin" {
                        Divider()
                        TabButton(title: "New Employee", image: "logo.playstation")
                        Divider()
                        TabButton(title: "New Shift", image: "loupe")
                        Divider()
                        TabButton(title: "New Announcement", image: "calendar")
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
            
            
            if UserDefaults.standard.bool(forKey: "isFirstSignIn") == true {
                viewModel.fetchData()
                viewModel.fetchCurrentUser()
                UserDefaults.standard.set(false, forKey: "isFirstSignIn")
            }
            
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
        .background(ColorIndicator.SideMenuColor)
        .fullScreenCover(isPresented: $isShowingLogIn) {
            SignInView()
        }
        
    }
    
    var profileHeaderView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 65, height: 65)
            
            Text(viewModel.currentUser.firstName)
                .font(.title2.bold())
            Text(viewModel.currentUser.costCenter)
                .font(.callout)
                .fontWeight(.semibold)
            
            HStack(spacing: 12) {
                Button {
                    
                } label: {
                    Label {
                        Text("Accepted Job shifts")
                    } icon: {
                        Text("4")
                            .fontWeight(.bold)
                    }
                }
            }
            .foregroundColor(.primary)
            
            
            
        }
        .padding([.horizontal,.leading])
    }
    
    // we dont want to use if statments
    @ViewBuilder
    func TabButton(title: String, image: String) -> some View {
        if title == "LogOut" {
            Button {
                do {
                    try Auth.auth().signOut()
                    isShowingLogIn = true
                } catch {
                    print(error)
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
            
        } else {
            NavigationLink {
                // I would just put a whole view in here for that thing
                // if text == Calendar than I will go to this view
                
                if (title == "Calendar") {
                    CalendarView(shiftViewModel: shiftViewModel, viewModel: viewModel)
                    //                        .onAppear(){
                    //                            showMenu = false
                    //                        }
                } else if (title == "All Shifts") {
                    VStack {
                        Button("fetch all shifts") {
                            //shiftViewModel.fetchAllShifts()
                            //print(shiftViewModel.allShifts)
                            
                        }
                        Button("fetch shifts desc") {
                            
                            print(shiftViewModel.CalendarShifts)
                            
                            shiftViewModel.fetchShiftMetaData()
                            print(shiftViewModel.CalendarShifts)
                        }
                        List(shiftViewModel.CalendarShifts) { shift in
                            VStack {
                                
                                Text(shift.id)
                                if shift.shift.count > 0 {
                                    Text(shift.shift[0].shiftName)
                                }
                                
                                
                                Text("\(shift.shiftDate)")
                            }
                        }
                        List(shiftViewModel.allShifts) { shift in
                            VStack {
                                
                                Text(shift.shiftName)
                                
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
                        .navigationBarTitle(title)
                        .navigationBarTitleDisplayMode(.inline)
                } else if (title == "New Shift") {
                    NewShiftView()
                        .navigationTitle(title)
                        .navigationBarTitleDisplayMode(.inline)
                        .onAppear(){
                            showMenu = false
                        }
                } else if (title == "Punch") {
                    
                    PunchView()
                        .navigationBarTitle(title)
                        .navigationBarTitleDisplayMode(.inline)
                        .onAppear(){
                            showMenu = false
                        }
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
                        .onAppear(){
                            showMenu = false
                        }
                } else if (title == "New Announcement") {
                    NewAnnouncementView(viewModel: viewModel)
                        .navigationTitle("New Announcemnt")
                        .navigationBarTitleDisplayMode(.inline)
                        .onAppear(){
                            showMenu = false
                        }
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

struct MainSideMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainSideMenu(showMenu: .constant(true), viewModel: userViewModel(), shiftViewModel: ShiftsViewModel())
        
    }
}

extension View {
    func getRect()->CGRect {
        return UIScreen.main.bounds
    }
}
