//
//  FirebaseManager.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 2/3/22.
//

import SwiftUI
import Firebase

class FirebaseManager: NSObject {
    let auth: Auth
   
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        
        self.auth = Auth.auth()
        
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
