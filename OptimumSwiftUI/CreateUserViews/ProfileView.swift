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
                    Text(viewModel.currentUser.id)
                    Text(viewModel.currentUser.costCenter)
                    Text(viewModel.currentUser.Qualifications)
                    Text(viewModel.currentUser.payType)
                    Text("\(viewModel.currentUser.hireDate)")
                    Text(viewModel.currentUser.phoneNumber)
                    Text(viewModel.currentUser.cellPhoneService)
                    Text(viewModel.currentUser.firstName)
                    Text("\(viewModel.currentUser.dateOfBirth)")
                }
                
                Text(viewModel.currentUser.PayRate)
                Text(viewModel.currentUser.EmergencyPhoneNumber)
                Text(viewModel.currentUser.EmergencyContact)
                Text(viewModel.currentUser.EmailAddress)
                Text(viewModel.currentUser.status)
            }
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
