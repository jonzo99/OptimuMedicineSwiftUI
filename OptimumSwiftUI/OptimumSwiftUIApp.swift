//
//  OptimumSwiftUIApp.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 9/22/21.
//

import SwiftUI

import Firebase
@main

struct OptimumSwiftUIApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    //@UIApplicationDelegateAdaptor(appDelegate.self)
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    
    var body: some Scene {
        WindowGroup {
//            if isLoggedIn == false {
//                LoginAndSignup(isLoggedIn: $isLoggedIn)
//                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
//            } else {
//                ContentView(isLoggedIn: $isLoggedIn)
//                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
//            }
            SignInView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
       
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       // FirebaseApp.configure()
        FirebaseApp.configure()
        let db = Firestore.firestore()
        
        return true
    }
}


extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        tapGesture.name = "MyTapGesture"
        window.addGestureRecognizer(tapGesture)
    }
 }
extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}



