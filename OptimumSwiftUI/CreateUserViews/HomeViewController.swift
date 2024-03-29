//
//  HomeViewController.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 1/27/22.
//

import SwiftUI

import UIKit
//https://www.youtube.com/watch?v=0HEYo3QRDfA
/// this is the youtube toturial that showed me how to do it
/// note to myself I need to start linking where I find the code that helped me solved this situation so I can go back and loook at them and they can help me outss
struct HomeViewController: View {
    @State var showMenu: Bool = false
    
    // Offset for Both Drag Gesuture and showing Menu...
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    
    // I should use an initializer here so I can enject what spefic thing I want to use.
    @ObservedObject var viewModel = userViewModel()
    @ObservedObject var shiftViewModel = ShiftsViewModel()
    @ObservedObject var annoucemntViewModel = AnnouncementViewModel()
    // Gesture Offset...
    @GestureState var gestureOffset: CGFloat = 0
    //@AppStorage("isFirstSignIn") var isFirstSignIn: Bool
    var body: some View {
        let sideBarWidth = getRect().width - 90
        NavigationView {
            
            
            
            HStack(spacing: 0) {
                MainSideMenu(showMenu: $showMenu, viewModel: viewModel, shiftViewModel: shiftViewModel)
                    
                VStack(spacing: 0) {
                    Text("Announcements")
                        .fontWeight(.bold)
                        .font(.title)
                    
                        .padding()
                    VStack {
                        List(annoucemntViewModel.announcements) { annoucemnt in
                            // I can do a pull to refresh
                            AnnouncementsRowView(announment: annoucemnt)
                                .listRowBackground(Color.blue.opacity(0.3))
                            
                        }
                        .listStyle(.plain)
                        
                        .cornerRadius(15)
                        
                    }
                    .padding([.trailing, .leading])
                    .cornerRadius(15)
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 3)
                    Spacer()
                    VStack(spacing: 0) {
                        HStack {
                            HomeNavButtons(buttonText: "Timer", tintColor: .red, content: ContentView())
                            
                            HomeNavButtons(buttonText: "All Shifts", tintColor: .green, content: CalendarView(shiftViewModel: shiftViewModel, viewModel: viewModel))
                        }
                        HStack{
                            HomeNavButtons(buttonText: "Punch", tintColor: .red, content: PunchView()
                                .navigationBarTitle("Punch")
                                .navigationBarTitleDisplayMode(.inline)
                            )
                            HomeNavButtons(buttonText: "My Shifts", tintColor: .green, content: CalendarViewForUser(shiftViewModel: shiftViewModel, viewModel: viewModel))
                        }
                    }
                }
                .frame(width: getRect().width)
                .overlay(
                    Rectangle()
                        .fill(
                            Color.primary
                                .opacity(Double((offset / sideBarWidth) / 5))
                        )
                        .ignoresSafeArea(.container, edges: .vertical)
                        .onTapGesture {
                            withAnimation{
                                showMenu.toggle()
                            }
                        }
                )
            }
            //.background(Color.red)
            //Max Size...
            .frame(width: getRect().width + sideBarWidth)
            .offset(x: -sideBarWidth / 2)
            .offset(x: offset > 0 ? offset : 0)
            // Gesture
            .gesture(
                DragGesture()
                    .updating($gestureOffset, body: {value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded(onEnd(value: ))
            )
            .onAppear {
                annoucemntViewModel.fetchAllAnnouncements()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("I have been tapped")
                        //withAnimation(.spring()) {
                            showMenu.toggle()
                        //}
                    }, label: {
                        Image(systemName: "list.bullet")
                            .foregroundColor(Color.gray)
                            
                    })
                }
                ToolbarItem(placement: .principal) {
                    Text("Home")
                        .bold()
                        .accessibilityAddTraits(.isHeader)
                }
            }
        }
        
        .background(Color.gray)
        .animation(.easeOut, value: offset == 0)
        .onChange(of: showMenu) { newValue in
            if showMenu && offset == 0 {
                offset = sideBarWidth
                lastStoredOffset = offset
                
            }
            if !showMenu && offset == sideBarWidth {
                offset = 0
                lastStoredOffset = 0
            }
        }
        .onChange(of: gestureOffset) { newValue in
            onChange()
        }
    }
    func onChange() {
        let sideBarWidth = getRect().width - 90
        offset = (gestureOffset != 0) ? (gestureOffset + lastStoredOffset < sideBarWidth ? gestureOffset + lastStoredOffset : offset) : offset
        
    }
    func onEnd(value: DragGesture.Value){
        let sideBarWidth = getRect().width - 90
        
        let translation = value.translation.width
        withAnimation{
            if translation > 0 {
                if translation > (sideBarWidth / 2) {
                    // showing menu...
                    offset = sideBarWidth
                    showMenu = true
                } else {
                    // Extra cases
                    if offset == sideBarWidth {
                        return
                    }
                    ///
                    offset = 0
                    showMenu = false
                }
                
            } else {
                if -translation > (sideBarWidth / 2) {
                    offset = 0
                    showMenu = false
                } else {
                    // this if statement seemed to deal with cases when the  user would swipe up
                    if offset == 0 || !showMenu {
                        return
                    }
                    offset = sideBarWidth
                    showMenu = true
                }
            }
        }
        //storing the last offset
        lastStoredOffset = offset
    }
}

struct HomeNavButtons<Content: View>: View {
    let buttonText: String
    let tintColor: Color
    let content: Content
    var body: some View {
        NavigationLink {
            content
        } label: {
            Text(buttonText)
                .frame(maxWidth: .infinity)
                .padding()
        }
        
        .padding()
        .buttonStyle(.bordered)
        .tint(tintColor)
    }
}

struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewController()
    }
}
