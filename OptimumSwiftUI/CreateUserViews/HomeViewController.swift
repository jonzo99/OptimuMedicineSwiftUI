//
//  HomeViewController.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 1/27/22.
//

import SwiftUI
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
    @ObservedObject  var viewModel = userViewModel()
    // Gesture Offset...
    @GestureState var gestureOffset: CGFloat = 0
    var body: some View {
        let sideBarWidth = getRect().width - 90
        NavigationView {
            
            
            
            HStack(spacing: 0) {
                MainSideMenu(showMenu: $showMenu, viewModel: viewModel)
                VStack(spacing: 0) {
                    Text("This is your home view")
                    Text("Here I can put anouncemets they have put")
                    //UserInfoView()
                }
                .frame(width: getRect().width)
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
                            .foregroundColor(.black)
                    })
                }
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .bold()
                        .accessibilityAddTraits(.isHeader)
                }
            }
        }
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
