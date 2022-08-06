//
//  LoginAndSignup.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 11/17/21.
//

import SwiftUI
import Firebase

struct LoginAndSignup: View {
    
    @AppStorage("signed_in") var currentUserSignedIn: Bool = false
    @State var showingSigninView = false
    //@Binding var isLoggedIn: Bool
    //@State var sign = SignInView(isLoggedIn: $isLoggedIn)
    
    var body: some View {
        if(currentUserSignedIn == true) {
            ContentView()
        } else {
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
                        
                        
//                        NavigationLink(destination: SignInView(isLoggedIn: isLoggedIn)) {
//                            
//                            Text("Sign In")
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.gray)
//                        }
                        
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
}
struct SignUpView: View {
    let db = Firestore.firestore()
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
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        
                        if let e = error {
                            print(e)
                            print(e.localizedDescription)
                        } else {
                            print(authResult)
                            
                            // I should store my dob as a date variable just in case I want to do some
                            let user = ["employeeId": 1002,
                                        "status": "Active",
                                        "firstName" : "jonzo",
                                        "lastName": "Jimenez",
                                        "dob": getDate5(date: "2001/01/01 14:12")!,
                                        "cellPhone": "7026019438",
                                        "cellPhoneService": "Tmobile",
                                        "emergencyContact": "Mom",
                                        "emergencyPhone": "7026446766",
                                        "HireDate": "June 1 2021"
                            ] as [String : Any]
                            // I should save the uuid because they said it makes it easier down the road
                            db.collection("users").addDocument(data: user) { error in
                                if let err = error {
                                    print("there was an issue saving you information")
                                    print(err)
                                } else {
                                    print("successfully saved data.")
                                    showContentView = true
                                }
                                
                            }
                        
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
    
    func getDate5(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        //dateFormatter.timeZone = TimeZone.current
        //dateFormatter.locale = Locale.current
        return dateFormatter.date(from: date) // replace Date String
    }
}


struct LoginAndSignup_Previews: PreviewProvider {
    static var previews: some View {
        LoginAndSignup()
    }
}

extension Date {
    func formatted(as string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = string
        return formatter.string(from: self)
    }
}
