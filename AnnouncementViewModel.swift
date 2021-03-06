//
//  AnnouncementViewModel.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 4/1/22.
//

import Foundation
import FirebaseFirestore
import Firebase

// I should create a protocol that fetehhesAll Annocements that way I
// I can create differnt Anouncents view models and get the information with fake
// data
class AnnouncementViewModel: ObservableObject {
    @Published var announcements = [Anouncement]()
    private var db = Firestore.firestore()
    func fetchAllAnnouncements() {
        db.collection("announcement").order(by: "createdDate", descending: true).getDocuments { (document, error) in
            guard let documents = document?.documents else {
                print("There was no documents")
                return
            }
            
            self.announcements = [Anouncement]()
            
            self.announcements = documents.map { (querySnapshot) -> Anouncement in
                let data = querySnapshot.data()
                let userId = querySnapshot.documentID
                let createdDate = (data["createdDate"] as? Timestamp)?.dateValue() ?? Date()
                let createdBy = data["createdBy"] as? String ?? ""
                let message = data["message"] as? String ?? ""
                let subject = data["subject"] as? String ?? ""
                
                return Anouncement(id: userId, createdBy: createdBy, createdDate: createdDate, message: message, subject: subject)
            }
            
        }
        
    }
}
