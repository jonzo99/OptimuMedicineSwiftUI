//
//  MainSideMenu.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 1/28/22.
//

import SwiftUI
import FirebaseFirestore
import Firebase
import Combine
struct MainSideMenu: View {
    @Binding var showMenu: Bool
    @State var isShowingLogIn = false
    //@ObservedObject private var viewModel = userViewModel()
    //@Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: userViewModel
    @ObservedObject var shiftViewModel: ShiftsViewModel
    @State var isFirst = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            profileHeaderView
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Divider()
                    sideMenuButtons(title: "Profile", image: "person.fill", content: ProfileView(viewModel: viewModel))
                    if viewModel.currentUser.costCenter == "Admin" {
                        Divider()
                        sideMenuButtons(title: "New Employee", image: "logo.playstation", content: UserInfoView().onAppear{ showMenu = false})
                        Divider()
                        sideMenuButtons(title: "New Shift", image: "loupe", content: NewShiftView().onAppear{ showMenu = false})
                        Divider()
                        sideMenuButtons(title: "New Announcement", image: "calendar", content: NewShiftView().onAppear{ showMenu = false})
                    }
                    Divider()
                    TabButton(title: "LogOut", image: "power")
                    
                }
                .padding()
                .padding(.leading)
                .padding(.top, 35)
            }
        }
        
        .onAppear() {
            
            
            if UserDefaults.standard.bool(forKey: "isFirstSignIn") == true {
                viewModel.fetchData()
                viewModel.fetchCurrentUser()
                UserDefaults.standard.set(false, forKey: "isFirstSignIn")
            }
            
        }
        .padding(.top)
        .frame(maxWidth: .infinity, alignment: .leading)
        // Max Width
        .frame(width: getRect().width - 90)
        .frame(maxHeight: .infinity)
        .background(
            Color.primary
                .opacity(0.04)
                .ignoresSafeArea(.container, edges: .vertical)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ColorIndicator.SideMenuColor)
        .fullScreenCover(isPresented: $isShowingLogIn) {
            SignInView()
        }
        
    }
    
    var profileHeaderView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 65, height: 65)
            
            Text(viewModel.currentUser.firstName)
                .font(.title2.bold())
            Text(viewModel.currentUser.costCenter)
                .font(.callout)
                .fontWeight(.semibold)
            
            HStack(spacing: 12) {
                Button {
                    
                } label: {
                    Label {
                        Text("Accepted Job shifts")
                    } icon: {
                        Text("4")
                            .fontWeight(.bold)
                    }
                }
            }
            .foregroundColor(.primary)
            
            
            
        }
        .padding([.horizontal,.leading])
    }
    
    
    struct sideMenuButtons<Content: View>: View {
        let title: String
        let image: String
        let content: Content
        var body: some View {
            NavigationLink {
                self.content
                    .navigationBarTitle(title)
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                HStack(spacing: 14) {
                    Image(systemName: image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 22, height: 22)
                    Text(title)
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    @ViewBuilder
    func TabButton(title: String, image: String) -> some View {
        if title == "LogOut" {
            Button {
                do {
                    try Auth.auth().signOut()
                    isShowingLogIn = true
                } catch {
                    print(error)
                }
            } label: {
                HStack(spacing: 14) {
                    Image(systemName: image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 22, height: 22)
                    Text(title)
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
struct MainSideMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainSideMenu(showMenu: .constant(true), viewModel: userViewModel(), shiftViewModel: ShiftsViewModel())
        
    }
}

extension View {
    func getRect()->CGRect {
        return UIScreen.main.bounds
    }
}
