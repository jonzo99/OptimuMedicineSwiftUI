//
//  userViewModel.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 2/1/22.
//

import Foundation
import FirebaseFirestore
import Firebase

class userViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var currentUser = User(id: "", lastName: "")
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("There was no documents")
                return
            }
                self.users = documents.map { (querySnapshot) -> User in
                    let data = querySnapshot.data()
                    
                    let lastName = data["lastName"] as? String ?? ""
                    let userId = data["id"] as? String ?? ""
                    //I see that I actually do get all of my users information I dont know why it doesnt save
                    print(lastName)
                    return User(id: userId, lastName: lastName)
                }
            
        }
       
    }
    func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print(uid)
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Faild", error)
            }
            
//            guard let data = snapshot?.data() else { return
//                print("errr1234")
//            }
            if let data = snapshot?.data() {
                let lastName = data["lastName"] as? String ?? ""
                let userId = data["id"] as? String ?? ""
                self.currentUser = User(id: userId, lastName: lastName)
            } else {
                "There was an issue getting the current user"
            }
            //self.currentUser = data
            
        }
        
    }
}
