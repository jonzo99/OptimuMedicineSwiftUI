//
//  Announcement.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 3/19/22.
//

import Foundation

struct Anouncement: Identifiable {
    var id = UUID().uuidString
    var createdBy = ""
    var createdDate = Date()
    var message = ""
    var subject = ""
}
