//
//  OnBoardingView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 2/27/22.
//

import SwiftUI

struct OnBoardingView: View {
    var body: some View {
        VStack{
            if UserDefaults.standard.bool(forKey: "isFirstSignIn") == true {
                //SignInView()
                HomeViewController()
            } else {
                HomeViewController()
            }
        }
        
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
