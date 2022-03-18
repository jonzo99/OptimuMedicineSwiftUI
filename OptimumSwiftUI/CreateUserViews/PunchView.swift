//
//  PunchView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 2/26/22.
//

import SwiftUI
import MapKit

struct PunchView: View {
    @StateObject private var punchViewModel = PunchViewModel()
    @State var showAlert = false
    var body: some View {
        ZStack {
            VStack {
                Map(coordinateRegion: $punchViewModel.region, showsUserLocation: true)
                    //.ignoresSafeArea()
                    .accentColor(.pink)
                    .onAppear {
                        punchViewModel.checkIfLocationServicesIsEnabled()
                    }
                Spacer()
                
                
//                    .overlay(content: {
//                        Spacer()
//                        VStack {
//                            Spacer()
//                            Button("Punch In") {
//                                print("pucn")
//                            }
//                        }
//
//                    })
            }
            VStack {
                Spacer()
                Spacer()
                Button("PUNCH IN") {
                    print("hey")
                    showAlert = true
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .frame(maxWidth: .infinity)
                .padding()
                Spacer()
                //.background(Color.red)
                
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Confirm"), message: Text("Confirm Punch In"), primaryButton: .default(Text("Yes🚑")) {
                    print("Do Action to punch in")
                }, secondaryButton: .cancel(Text("NO 😕")))
            })
            
        }
        
       
    }
}
struct PunchView_Previews: PreviewProvider {
   
    static var previews: some View {
        PunchView()
    }
}
