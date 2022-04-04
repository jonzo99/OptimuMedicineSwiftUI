//
//  NewAnnouncementView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 4/1/22.
//

import SwiftUI
import FirebaseFirestore
struct NewAnnouncementView: View {
    let db = Firestore.firestore()
    @State var message = ""
    @State var subject = ""
    @ObservedObject var viewModel: userViewModel
    @Environment(\.presentationMode) var presentationMode
    // I just need to add a save button and than I should be good
    // and just the
    var body: some View {
        List  {
            InputTextField(text: "Subject", stringImage: "t", variable: $subject)
            InputTextField(text: "Message", stringImage: "t", variable: $message)
            
            Text("Created By:\(viewModel.currentUser.firstName)")
                .customTextField()
        }
        .toolbar {
            ToolbarItem {
                Text("Save")
                    .tint(.blue)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        createNewAnnoucement()
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
    }
    
    
    func createNewAnnoucement() {
        
        // I dont need to set an id right now.
        // I just need to collect it and have it as the
        // doucemnt collection path so for my use i will have it
        let newAnn = ["subject": subject,
                      "message": message,
                      "createdBy": viewModel.currentUser.firstName,
                      "createdDate": Date()] as [String : Any]
        db.collection("announcement").document().setData(newAnn) { error in
            if let err = error {
                print("there was an error", err)
            } else {
                print("That announcent have been made succesfully")
            }
        }
    }
}


struct customTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(8)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
    }
}

struct InputTextField: View {
    var text: String
    var stringImage: String
    @Binding var variable: String
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            Text(text)
                .fontWeight(.semibold)
            HStack {
                Image(systemName: "number")
                TextField(text, text: $variable)
                
            }
            .customTextField()
        }
    }
}

struct NewAnnouncementView_Previews: PreviewProvider {
    static var previews: some View {
        NewAnnouncementView(viewModel: userViewModel())
    }
}

extension View {
    func customTextField() -> some View {
        self.modifier(customTextFieldModifier())
    }
}
