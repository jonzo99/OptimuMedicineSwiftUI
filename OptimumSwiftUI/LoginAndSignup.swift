//
//  LoginAndSignup.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 11/17/21.
//

import SwiftUI
import Firebase
struct SignInView: View {
    // When I enter this view I should have my keyboard up inside the email and the the keyboaerd button should say next and it should take me to the password view. Than change it to say sign in and than let the user sign
    @State var email = ""
    @State var password = ""
    @State var showContentView = false
    
    enum Field {
        case email
        case password
    }
    @FocusState private var focusedField: Field?
    var body: some View {
        ZStack {
            RadialGradient (
                gradient: Gradient(colors: [Color.red, Color.white, Color.blue]),
                center: .topLeading,
                startRadius: 5,
                endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            VStack {
                Text("Log In")
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
                VStack(spacing: 1) {
                    HStack {
                        Text("Email")
                            .padding(.leading)
                            .multilineTextAlignment(.trailing)
                        Spacer()
                    }
                    .padding(.bottom, 1)
                    TextField("Enter email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .padding(.trailing)
                        .padding(.leading)
                        .focused($focusedField, equals: .email)
                        .task {
                            DispatchQueue.main.asyncAfter(deadline: .now() +  0.5) {  /// Anything over 0.5 seems to work
                                        self.focusedField = .email
                                   }
                        }
                        .keyboardType(.emailAddress)
                        .submitLabel(.next)
                }

                
                VStack(spacing: 1) {
                    HStack {
                        Text("Password")
                            .padding(.leading)
                            .multilineTextAlignment(.trailing)
                        Spacer()
                    }
                    SecureField("Enter Password", text: $password)
                        .textContentType(.password)
                        .textFieldStyle(.roundedBorder)
                        .padding(.trailing)
                        .padding(.leading)
                        .submitLabel(.go)
                        .focused($focusedField, equals: .password)
                }
                Spacer()
                Spacer()
                Button {
                    showContentView = true
                    
                } label: {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.gray)
                .padding(30)
            }
            
        }
        .fullScreenCover(isPresented: $showContentView) {
            ContentView()
        }
        
        .onSubmit {
            switch focusedField {
            case .email:
                focusedField = .password
            default:
                print("you have submitted")
            }
        }
    }
}
struct LoginAndSignup: View {
    
    @AppStorage("signed_in") var currentUserSignedIn: Bool = false
    @State var showingSigninView = false
    
    @State var sign = SignInView()
    
    var body: some View {
        NavigationView {
            
            ZStack {
                RadialGradient (
                    gradient: Gradient(colors: [Color.red, Color.white, Color.blue]),
                    center: .topLeading,
                    startRadius: 5,
                    endRadius: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
                VStack {
                    
                    Image("CompanyLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    //.foregroundColor(.white)
                    Text("OptimuMedicine")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    
                    NavigationLink(destination: SignInView()) {
                        
                        Text("Sign In")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                    }
                    
                    NavigationLink(destination: SignUpView()) {
                        
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                    }
                }
                .padding(30)
                
            }
            // if user is signed in
            // profile view
            // else
            // onboarding view
            
        }
    }
}
struct SignUpView: View {
    
    @State var email = ""
    @State var password = ""
    @State var password1 = ""
    @State var showContentView = false
    
    enum Fieldd {
        case email
        case password
        case password1
    }
    @FocusState private var focusedField: Fieldd?
    
    var body: some View {
        ZStack {
            RadialGradient (
                gradient: Gradient(colors: [Color.red, Color.white, Color.blue]),
                center: .topLeading,
                startRadius: 5,
                endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            
            VStack {
                Text("Sign Up")
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
                VStack(spacing: 1) {
                    HStack {
                        Text("Email")
                            .padding(.leading)
                            .multilineTextAlignment(.trailing)
                        Spacer()
                    }
                    .padding(.bottom, 1)
                    TextField("Enter email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .padding(.trailing)
                        .padding(.leading)
                        .focused($focusedField, equals: .email)
                        .task {
                            DispatchQueue.main.asyncAfter(deadline: .now() +  0.5) {  /// Anything over 0.5 seems to work
                                self.focusedField = .email
                            }
                        }
                        .keyboardType(.emailAddress)
                        .submitLabel(.next)
                }
                
                
                VStack(spacing: 1) {
                    HStack {
                        Text("Password")
                            .padding(.leading)
                            .multilineTextAlignment(.trailing)
                        Spacer()
                    }
                    TextField("Enter Password", text: $password)
                        .textContentType(.password)
                        .textFieldStyle(.roundedBorder)
                        .padding(.trailing)
                        .padding(.leading)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .password)
                }
                
                VStack(spacing: 1) {
                    HStack {
                        Text("Re-Enter Password")
                            .padding(.leading)
                            .multilineTextAlignment(.trailing)
                        Spacer()
                    }
                    TextField("Confirm Password", text: $password1)
                        .textContentType(.password)
                        .textFieldStyle(.roundedBorder)
                        .padding(.trailing)
                        .padding(.leading)
                        .submitLabel(.go)
                        .focused($focusedField, equals: .password1)
                }
                Spacer()
                Spacer()
                Button {
                    showContentView = true
                    
                } label: {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.gray)
                .padding(30)
            }
        }
        .fullScreenCover(isPresented: $showContentView) {
            ContentView()
        }
        
        .onSubmit {
            switch focusedField {
            case .email:
                focusedField = .password
            case .password:
                focusedField = .password1
            default:
                print("you have submitted")
            }
        }
    }
}


struct LoginAndSignup_Previews: PreviewProvider {
    static var previews: some View {
        LoginAndSignup()
    }
}
