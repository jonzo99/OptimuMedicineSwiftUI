//
//  SignInView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 1/27/22.
//

import SwiftUI

import SwiftUI
import Firebase
struct SignInView: View {
    // When I enter this view I should have my keyboard up inside the email and the the keyboaerd button should say next and it should take me to the password view. Than change it to say sign in and than let the user sign
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
                
                VStack(spacing: 1) {
                    HStack {
                        Text("Employee Id")
                            .padding(.leading)
                            .multilineTextAlignment(.trailing)
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
                        } else {
                            // this is the correct way to do it. Im creating a new user and the document id with be the current user id and the setData is whatever data I want to save for that user.
//                            db.collection("users").document("uid").setData(["id": "uid", "lastName": "Jimenez"])\
                            isFirstSignIn  = true
                            showContentView = true
                            isLoggedIn = true
                            //viewModel.fetchCurrentUser()
//                            print(authResult?.user.uid)
//                            if let uid = authResult?.user.uid {
//                                let user = [
//                                    "id": uid,
//                                    "lastName": "Jimenez"
//                                ]
                                //                            // I should save the uuid because they said it makes it easier down the road
//                                db.collection("users").addDocument(data: user) { error in
//                                    if let err = error {
//                                        print("there was an issue saving you information")
//                                        print(err)
//                                    } else {
//                                        print("successfully saved data.")
//                                        showContentView = true
//                                    }
//
//                                }
                            //}
                            
                            
                            
                            
                        }
                    }
                    
                    // this is where I need to set the value of the the AppStore for if the user is signin in or not in here
                    //currentUserSignedIn = true
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
