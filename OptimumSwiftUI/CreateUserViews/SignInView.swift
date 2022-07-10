//
//  SignInView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 1/27/22.
//

import SwiftUI

import Firebase
struct SignInView: View {
    @State var email = "test@mail.com"
    @State var password = "12345678"
    @State var employeeId = ""
    @State var showContentView = false
    let db = Firestore.firestore()
    enum Field {
        case email
        case password
    }
    @AppStorage("isFirstSignIn") var isFirstSignIn: Bool = false
    @FocusState private var focusedField: Field?
    @State var isLoggedIn: Bool = true
    
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
                        Spacer()
                    }
                    .padding(.bottom, 1)
                    TextField("Enter email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .padding([.trailing, .leading])
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
                        Spacer()
                    }
                    SecureField("Enter Password", text: $password)
                        .textContentType(.password)
                        .textFieldStyle(.roundedBorder)
                        .padding([.trailing, .leading])
                        .submitLabel(.go)
                        .focused($focusedField, equals: .password)
                }
                
                VStack(spacing: 1) {
                    HStack {
                        Text("Employee Id")
                            .padding(.leading)
                        Spacer()
                    }
                    TextField("Employee ID", text: $employeeId)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }
                Spacer()
                Spacer()
                Button {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error)
                            isFirstSignIn  = true
                            showContentView = true
                            isLoggedIn = true
                        } else {
                            isFirstSignIn  = true
                            showContentView = true
                            isLoggedIn = true
                        }
                    }
                
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
            HomeViewController()
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

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        // I have to put fake data here
        SignInView()
    }
}
