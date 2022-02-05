//
//  SideMenuView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 11/24/21.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @State var isShowingLogInView = false
    @Binding var isLoggedIn: Bool
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                SideMenuHeaderView(isShowing: $isShowing)
                    .frame(height: 240)
                HStack(spacing: 16) {
                    Image(systemName: "escape")
                        .frame(width: 24, height: 24)
                    //Text("Log Out")
                     //   .font(.system(size: 15, weight: .semibold))
                    Button("Log Out") {
                        print("Log out button has been taped")
                        isShowingLogInView = true
                    }
                    .font(.system(size: 15, weight: .semibold))
                    Spacer()
                }
                .foregroundColor(.white)
                .padding()
                ForEach(0..<3) { _ in
                    SideMenuOptionView()
                }
                Spacer()
            }
            .fullScreenCover(isPresented: $isShowingLogInView) {
                LoginAndSignup(isLoggedIn: isLoggedIn)
            }
        } .navigationBarHidden(true)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true), isLoggedIn: .constant(true))
    }
}
