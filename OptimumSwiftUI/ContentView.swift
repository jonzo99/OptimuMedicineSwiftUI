//
//  ContentView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 9/22/21.
//
// Test1
import SwiftUI
//import NotificationCenter
import UserNotifications
import AVFAudio


struct ContentView: View {
    //init() {
        //UIToolbar.appearance().barTintColor = UIColor.red
       // UITabBar.appearance().backgroundColor = UIColor.gray
        //UINavigationBar.appearance().backgroundColor = .lightGray
    //}
    @State var title = "Hamilton"
    @State private var isShowing = false
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("timePassedInBack") var timePassedInBack: Int = 0
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                if isShowing {
                    SideMenuView(isShowing: $isShowing, isLoggedIn: $isLoggedIn)
                }
                TabView {
                    HamiltonView()
                        .tabItem{
                            Image(systemName: "square.fill")
                            Text("HAMILTON")
                        }
                        .onAppear(perform: {
                            title = "Hamilton"
                        })
                    
                    FreeFlowView()
                        .tabItem {
                            Image(systemName: "square.fill")
                            Text("Free Flow")
                        }
                        .onAppear(perform: {
                            title = "FreeFlow"
                            
                        })
                }
                /*
                .frame(
                                width: UIScreen.main.bounds.width ,
                                height: UIScreen.main.bounds.height
                            )*/
                //.background()
                .cornerRadius(isShowing ? 20 : 0)
                .offset(x: isShowing ? 300 : 0, y: isShowing ? 44 : 0 )
                .scaleEffect(isShowing ? 0.8 : 1)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("I have been tapped")
                        withAnimation(.spring()) {
                            isShowing.toggle()
                        }
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
        /*.onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                print("FREEFLOW IS INACTIVE")
                //sActive = false
            } else if newPhase == .active {
            print("FREEFLOW IS ACTIVE")
                
                
            } else if newPhase == .background {
                print("FREEFLOW IS IN BACKGROUND")
            }
        }*/
        
    }
}


struct PrimaryLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 26, weight: .medium, design: .rounded))
    }
}
struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(1)
            .background(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
            //.shadow(color: .gray, radius: 10)
    }
}

    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isLoggedIn: .constant(true))
    }
}
