//
//  SideMenuHeaderView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 11/24/21.
//

import SwiftUI

struct SideMenuHeaderView: View {
    @Binding var isShowing: Bool
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                withAnimation(.spring()) {
                    isShowing.toggle()
                }
            }, label: {
                Image(systemName: "xmark")
                    .frame(width: 40, height: 32)
                    .foregroundColor(.white)
                    .padding()
            })
            VStack(alignment: .leading) {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .padding(.bottom, 16)
                    .foregroundColor(.red)
                
                Text("Jonzo jfjdsj")
                    .font(.system(size: 24, weight: .semibold))
                Text("@jonzo")
                    .padding(.bottom,24)
                    .font(.system(size: 14))
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Text("1,345").bold()
                        Text("Following")
                    }
                    HStack(spacing: 4) {
                        Text("607").bold()
                        Text("Followers")
                    }
                    Spacer()
                }
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
        }
    }
}

struct SideMenuHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuHeaderView(isShowing: .constant(true))
    }
}
