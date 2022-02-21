//
//  ColorIndicator.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 2/19/22.
//

import Foundation
import SwiftUI

struct ColorIndicator {
    //static let red = Color.red
    static let skyBlue = Color(red: 0.4627, green: 0.8392, blue: 1.0)
    static let covidColor = Color.red
    //
    static func getColorForShift(shiftName: String) -> Color {
        
        if shiftName.contains("Test") {
            return covidColor
        }
        if shiftName.contains("OM") {
            return skyBlue
        }
        return Color.black
    }
}
