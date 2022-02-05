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
    @State var isFirst = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 14) {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 65, height: 65)
                    
                Text(viewModel.currentUser.lastName)
                    .font(.title2.bold())
                    
                List(viewModel.users) { usser in
                    VStack {
                        Text(usser.lastName)
                        Text(usser.id)
                    }
                }

//                Button("Text") {
//                    viewModel.fetchData()
//                }

                .foregroundColor(Color.red)
                Text("Vaccinator")
                    .font(.callout)
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
                VStack(alignment: .leading, spacing: 45) {
                    // Tab Button
                    TabButton(title: "Profile", image: "person.fill")
                    TabButton(title: "Calendar", image: "calendar")
                    TabButton(title: "Punch", image: "clock")
                    TabButton(title: "New Employee", image: "logo.playstation")
                    TabButton(title: "timer", image: "timer")
                    TabButton(title: "LogOut", image: "power")
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
                    CalendarView()
                } else if (title == "timer") {
                    // I can make it always true because I created this before as my home view I will need to fix it to remove this
                    ContentView(isLoggedIn: .constant(true))
                    // I think this might make my logic a bit easier all I have to do is view will appear and view will disappear and I just have to keep track of that
                    // I can also make them into seperate views So I dont have to worry about the things now saving or calling stuff.
                } else if (title == "New Employee") {
                    UserInfoView()
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
