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
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("timePassedInBack") var timePassedInBack: Int = 0
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        ZStack {
            
            TabView {
                HamiltonView()
                    .tabItem{
                        Image(systemName: "square.fill")
                        Text("HAMILTON")
                    }
                    .navigationBarTitle("Hamilton")
                
                FreeFlowView()
                    .tabItem {
                        Image(systemName: "square.fill")
                        Text("Free Flow")
                    }
                    .navigationBarTitle("Hamilton")
                    
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
