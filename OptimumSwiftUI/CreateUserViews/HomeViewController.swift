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
    @State var title = "Home"
    @State private var isShowing = false
    @State var showMenu: Bool = false
    
    // Offset for Both Drag Gesuture and showing Menu...
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    @ObservedObject var viewModel = userViewModel()
    // Gesture Offset...
    @GestureState var gestureOffset: CGFloat = 0
    @State var currentUserEmail = ""
    //@AppStorage("isFirstSignIn") var isFirstSignIn: Bool
    var body: some View {
        let sideBarWidth = getRect().width - 90
        NavigationView {
            
            
            
            HStack(spacing: 0) {
                MainSideMenu(showMenu: $showMenu, viewModel: viewModel)
                    //.foregroundColor(.pink)
                    
                VStack(spacing: 0) {
                    Text("Announcements")
                        .fontWeight(.bold)
                        .font(.title)
                    
                        .padding()
                    VStack {
                        //Color.red
                          //  .ignoresSafeArea()
                        
                        List(viewModel.users) { usser in
                            VStack{
                                //HStack {
                                    Text(usser.lastName)
                                    Text(usser.id)
                                Text(usser.lastName)
                                Text(usser.lastName)
                                //}
                                
                            }
                            .listRowBackground(Color.red.opacity(0.7))
                            //.listRowBackground(Color.red.ignoresSafeArea())
                            
                        }
                        .listStyle(.plain)
                        //.background(Color.red)
                        //.listStyle(InsetListStyle())
                        //.listStyle(InsetListStyle)
                        
                        .cornerRadius(15)
                        
                    }
                    .padding(.trailing)
                    .padding(.leading)
                    //.background(Color.pink)
                    .cornerRadius(15)
                    //.frame(maxWidth: .infinity)
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 3)
                    Spacer()
                    HStack{
                        NavigationLink {
                            PunchView()
                                .navigationBarTitle("Punch")
                                .navigationBarTitleDisplayMode(.inline)
//                                .onAppear(){
//                                    showMenu = false
//                                }
                        } label: {
                            Text("Punch In")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        
                        .padding()
                        .buttonStyle(.bordered)
                        .tint(Color.red)
                        //Button
                        Button {
                            print("Navigate to the screen")
                        } label: {
                            Text("Calendar")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        
                        .padding()
                        .buttonStyle(.bordered)
                        .tint(Color.green)
                    }
                   
                    //.background(Color.pink)
//                    Text("these should be buttonsdfgdgfdgss")
//                    Text("these should be buttonsdfgdfgdfgdfg")
                    //Spacer()
//                    List(viewModel.users) { usser in
//                        VStack {
//                            Text(usser.lastName)
//                            Text(usser.id)
//                        }
//                    }
                    //UserInfoView()
                }
                .frame(width: getRect().width)
                //.background(Color.blue.ignoresSafeArea())
                // BG when menu is showing...
                // this is for when I click on the out side of the screen that I am able to go back to my main screen instead of only just clicking on the button
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
                    Text(title)
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

struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewController()
    }
}
