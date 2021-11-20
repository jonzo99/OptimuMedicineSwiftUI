//
//  OnboardingView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 11/17/21.
//

import SwiftUI


struct OnboardingView: View {
    // Onboarding states:
    /*
     0 - Welcome screen
     1 - Add name
     2 - Add age
     3 - Add gender
     */
    @State var onboardingState: Int = 0
    
    var body: some View {
        ZStack {
            // content
            // i can create each on a different view for which state I am in
            // So than I will have 1 where I click sign in I would have to input my email and password
            // than i will have 2 where person clicks on sing up and take them to another view to create there account
            ZStack {
                switch onboardingState {
                case 0:
                    welcomeSection
                case 1:
                    signInSection
                case 2:
                    signUpSection
                default:
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.green)
                }
            }
        }
    }
    
   
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .background(Color.purple)
    }
}

// MARK: COMPONETS
extension OnboardingView {
    
    private var welcomeSection: some View {
        ZStack {
            RadialGradient (
                gradient: Gradient(colors: [Color.red, Color.white, Color.blue]),
                center: .topLeading,
                startRadius: 5,
                endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            VStack(spacing: 40) {
                Spacer()
                Image("CompanyLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    //.foregroundColor(.white)
                Text("OptimuMedicine")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Spacer()
                Spacer()
                
                Button {
                    print("tapped")
                    onboardingState = 1
                } label: {
                    Text("Sign in")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        
                    
                }
                
                .background(Color.gray)
                
                Button {
                    print("Sing UP")
                    onboardingState = 2
                } label: {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.gray)
            }
            .padding(30)
            
        }
    }
    
    private var signInSection: some View {
        ZStack {
            RadialGradient (
                gradient: Gradient(colors: [Color.red, Color.white, Color.blue]),
                center: .topLeading,
                startRadius: 5,
                endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            VStack() {
                
                Text("Log in")
                    .fontWeight(.semibold)
                    .font(.title)
                Spacer()
            }
                
        }
    }
    
    private var signUpSection: some View {
        ZStack {
            RadialGradient (
                gradient: Gradient(colors: [Color.red, Color.white, Color.blue]),
                center: .topLeading,
                startRadius: 5,
                endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            VStack(spacing: 40) {
                Spacer()
                Image("CompanyLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    //.foregroundColor(.white)
                Text("signUP")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Spacer()
                Spacer()
                
                Button {
                    print("tapped")
                } label: {
                    Text("Sign in")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                }
                .background(Color.gray)
                
                Button {
                    print("Sing UP")
                } label: {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.gray)
            }
            .padding(30)
            
        }
    }
    
}
