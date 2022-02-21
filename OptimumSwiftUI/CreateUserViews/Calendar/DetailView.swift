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
import FirebaseFirestore
struct DetailView: View {
    @Binding var details: Shifts
    @Environment(\.presentationMode) var presentationMode
    @State var showAlert = false
    let db = Firestore.firestore()
    @State var selectedValue: String = ""
    @State var selectedKey: String = ""
    @ObservedObject var viewModel: userViewModel
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray
                    //.ignoresSafeArea()
                
                VStack {
                    Text(details.shiftName)
                        .font(.largeTitle.bold())
                        .border(Color.black)
                        .padding()
                    //Spacer()
                    HStack(spacing: 10) {
                        Text(dateFormatDDMMYY(date: details.startTime))
                            .font(.title2.bold())
                            .padding(.leading, 20)
                        Spacer()
                        Text(dateFormatHHMM(date: details.startTime))
                            .fontWeight(.semibold)
                        Text("-")
                            .fontWeight(.semibold)
                        Text(dateFormatHHMM(date: details.endTime))
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    List {
                        
                        ForEach(details.jobShifts.sorted(by: <), id: \.key) { key, value in
                            HStack {
                                Text(key)
                                Spacer()
                                Text(value)
    
                                
//                                if emp.job == "Site Lead" {
//                                    Image(systemName: "person.crop.circle.badge.exclamationmark").foregroundColor(.red).imageScale(.large)
//                                } else {
//                                    Image(systemName: "person.crop.circle.badge.checkmark").foregroundColor(.green).imageScale(.large)
//                                }
                            }
                            .listRowBackground(key.contains("empty") ? Color.green.opacity(0.4) : Color.gray.opacity(0.4))
                            .onTapGesture {
                                showAlert = true
                                selectedKey = key
                                selectedValue = value
                            }
                        }
                        
                    }
                    .listStyle(.plain)
                    
                    .cornerRadius(15)
                    .border(Color.black, width: 1)
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 2)
                    
                    //.padding()
                    //.frame(width: .infinity, height: 200, alignment: .center)
                    
                
                    //.background(Color.red.ignoresSafeArea())
                    //.listStyle(.sidebar)
                    
                    //Spacer()
                    //Spacer()
                    Text(details.comment)
                    Spacer()
                    
                    
                }
            }
            .navigationBarTitle("Pick Up Shift", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Confirm"), message: Text("Do you want to accept this job"), primaryButton: .default(Text("Yes🚑")) {
                    print("Hello world")
                    db.collection("shifts").whereField("id", isEqualTo: details.id).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("there was an error\(err)")
                        } else {
                            
                            let document = querySnapshot?.documents.first
                            var dic = details.jobShifts
                            dic.removeValue(forKey: selectedKey)
                            // here is where I would get the first and last name of selected user
                            // than I will set the
                            //dic["currentUser"] = selected value
                            dic[viewModel.currentUser.firstName] = selectedValue
                            document?.reference.updateData([
                                "comment": "Practice1",
                                "jobShifts": dic
                            ])
                            
                        }
                    }
                }, secondaryButton: .cancel(Text("NO 😕")))
            })
            
        }
        //.tint(.green)
        //.foregroundColor(Color.green)
    }
    
    func dateFormatDDMMYY(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        //dateFormatter.timeZone = TimeZone.current
        //dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    func dateFormatHHMM(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        //dateFormatter.timeZone = TimeZone.current
        //dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(details: .constant(Shifts(id: "id343", comment: "Behindthe school", jobShifts: ["0 empty": "Nurse", "Jonzo": "Nurse", "2 empty": "Admin"], shiftName: "OM 1", startTime: Date(), endTime: Date().addingTimeInterval(60 * 120))), viewModel: userViewModel())
            .previewInterfaceOrientation(.portrait)
    }
}

