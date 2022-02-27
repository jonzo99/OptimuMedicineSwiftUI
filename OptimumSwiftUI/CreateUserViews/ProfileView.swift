//
//  ProfileView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 2/6/22.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: userViewModel
    
    var body: some View {
        VStack {
            List {
                Group {
                    
                    ProfileRow(title: "First Name", content: viewModel.currentUser.firstName)
                    ProfileRow(title: "Email Address", content: viewModel.currentUser.EmailAddress)
                    ProfileRow(title: "Cost Center", content: viewModel.currentUser.costCenter)
                    ProfileRow(title: "Qualifications", content: viewModel.currentUser.Qualifications)
                    ProfileRow(title: "Pay Type", content: viewModel.currentUser.payType)
                    ProfileRow(title: "Pay Rate", content: viewModel.currentUser.PayRate)
                    ProfileRow(title: "Hire Date", content: "\(viewModel.currentUser.hireDate)")
                    ProfileRow(title: "Phone Number", content: viewModel.currentUser.phoneNumber)
                    
                }
                ProfileRow(title: "Cell Phone Service", content: viewModel.currentUser.cellPhoneService)
                ProfileRow(title: "DOB", content: "\(viewModel.currentUser.dateOfBirth)")
                ProfileRow(title: "Emergency Phone Number", content: viewModel.currentUser.EmergencyPhoneNumber)
                ProfileRow(title: "Emergency Contact", content: viewModel.currentUser.EmergencyContact)
                
                ProfileRow(title: "Status", content: viewModel.currentUser.status)
                ProfileRow(title: "ID", content: viewModel.currentUser.id)
            }
        }
    }
}

struct ProfileRow: View {
    var title: String
    var content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2){
            Text(title)
                .fontWeight(.semibold)
            HStack {
                //Image(systemName: "number")
//                TextField("Employee ID", text: $employeeId, onEditingChanged: { edit in
//                    self.isEditing = edit
//                })
                Text(content)
                
            }
            .frame(maxWidth: .infinity)
            //.padding()
            .padding(8)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.black))
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        // so here Im saying in the preview show everthing empty
        // but I can acually give it the values I want since it doesnt know what its going to get
        ProfileView(viewModel: userViewModel.init())
    }
}
