//
//  AnnouncementsRowView.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 4/3/22.
//

import SwiftUI

struct AnnouncementsRowView: View {
    var announment: Anouncement
    var body: some View {
        VStack {
            Text(announment.subject)
                .font(.title.bold())
            Text(announment.message)
                .font(.callout)
                .fontWeight(.semibold)
            
            HStack(alignment: .bottom) {
                Text(dateToString(date: announment.createdDate))
                Spacer()
                Text("Created by \(announment.createdBy)")
                
            }
            .padding(.top)
            .font(.footnote)
        }
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/YYYY H:mm a"
        //dateFormatter.timeZone = TimeZone.current
        //dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date) // replace Date String
    }
}

struct AnnouncementsRowView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementsRowView(announment: Anouncement(id: "33225", createdBy: "Jonzo", createdDate: Date(), message: "Just wanted to remind everyone that there is going to be a party tommorow at the office", subject: "End Of Year Party"))
    }
}
