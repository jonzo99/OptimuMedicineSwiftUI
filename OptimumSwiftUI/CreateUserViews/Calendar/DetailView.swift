//
//  DetailView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 1/29/22.
//

import SwiftUI
import UIKit
import Foundation
import Combine

struct DetailView: View {
    @Binding var details: Task
    @Environment(\.presentationMode) var presentationMode
    @State var showAlert = false
    var body: some View {
//        VStack {
//            //Text("\(details.emp[0])")
//            //Text("\(details.time)")
//            Text(details.title)
//            Text(details.detail)
//                .onAppear(perform: {
//                    print(details.emp)
//                    print(details.time)
//                })
//            Text(details.emp[0].name)
//            //for details.emp.count in pep {
//            //    pep.name
//            //}
//            ForEach(details.emp.indices) { i in
//                HStack {
//                    //Text(emp.name)
//                    //Text(emp.job)
//                    Text(details.emp[i].name)
//                    Text(details.emp[i].job)
//                }
//            }
//
//        }
        NavigationView {
            ZStack {
                Color.red
                    //.ignoresSafeArea()
            
            VStack {
                Text(details.title)
                    .font(.largeTitle.bold())
                    .border(Color.black)
                Text(details.detail)
                    .font(.title)
                    .fontWeight(.semibold)
                Text(details.time, style: .time)
                    .onAppear(){
                        print(details.time)
                    }
                Text(details.time, style: .date)
                Spacer()
            
                List {
                    ForEach(details.emp) { emp in
                        HStack {
                            Text(emp.name)
                            Text(emp.job)
                            Spacer()
                            if emp.job == "Site Lead" {
                                Image(systemName: "person.crop.circle.badge.exclamationmark").foregroundColor(.red).imageScale(.large)
                            } else {
                                Image(systemName: "person.crop.circle.badge.checkmark").foregroundColor(.green).imageScale(.large)
                            }
                        }
                        .onTapGesture {
                            showAlert = true
                        }
                    }
                }
                Text("hey")
                Spacer()
                
            }
            }
            .navigationBarTitle("Detail View", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .alert(isPresented: $showAlert, content: {
//            Alert(title: Text("Do you want to accept this job"),
//            message: Text("this is why"),
//                  dismissButton: .default(Text("Accept")))
            Alert(title: Text("Alert"), message: Text("Do you want to accept this job"), primaryButton: .default(Text("Confirm")), secondaryButton: .cancel())
        })
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(details: .constant(Task(title: "MVS - Southern Nevada", emp: [Pruitt, Valdez, Williams, Anderson], detail: des)))
.previewInterfaceOrientation(.portrait)
    }
}

