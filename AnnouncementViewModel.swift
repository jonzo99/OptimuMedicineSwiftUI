//
//  AnnouncementViewModel.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 4/1/22.
//

import Foundation
import FirebaseFirestore
import Firebase

class AnnouncementViewModel: ObservableObject {
    @Published var announcements = [Anouncement]()
    
    private var db = Firestore.firestore()
    // I have to create a seperate file that just holds this view
    func fetchAllAnnouncements() {
        db.collection("announcement").order(by: "createdDate", descending: true).getDocuments { (document, error) in
            guard let documents = document?.documents else {
                print("There was no documents")
                return
            }
            
            self.announcements = [Anouncement]()
            
            self.announcements = documents.map { (querySnapshot) -> Anouncement in
                let data = querySnapshot.data()
                // so dont create a speacial id let firebase handle that.
                // let me just always retrive it.
                let userId = querySnapshot.documentID
                // the dates I am not retrieving them correctly and they are using the defualt date
                let createdDate = (data["createdDate"] as? Timestamp)?.dateValue() ?? Date()
                let createdBy = data["createdBy"] as? String ?? ""
                let message = data["message"] as? String ?? ""
                let subject = data["subject"] as? String ?? ""
                
                return Anouncement(id: userId, createdBy: createdBy, createdDate: createdDate, message: message, subject: subject)
            }
            
        }
        
    }
}
