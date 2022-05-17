//
//  Utilities.swift
//  OptimumSwiftUI
//
//  Created by Jonzo Jimenez on 5/14/22.
//

import Foundation

struct Utilities {
    static let qulifications = ["None", "Admin","AEMT","AOC","CCT Paramedic","EMT","GOC","Nurse","Paramedic","CFRN","CCRN","CEN","Instructor","MD","EMT Intern","Paramedic Intern","CCT Intern","Dispatcher","COVID Tester","RT","Vaccinator","Site Lead","PR","Data Entry"
    ]
    
    static let masterShifts = ["OM 1", "EAL 1", "Instructor", "EAL 2", "OM 2", "Dispatch", "Education", "AIR1", "COVID Tester", "PR Standby", "Douglas School", "Decatur COVID Tester", "Venetian Testing", "Impact Wrestling", "MVS", "Accounting1", "MVS - Southern Nevada", "MVS - Rural", "MVS - Reno Area", "DDWTD s3", "Travel", "Office Hours", "Carson City School Testi", "SNHD Homebound", "Bookkeeper", "SNHD Strike Team", "Office Administrator", "Elko County School Testi", "CG Testing"
    ]
    
    static let costCenter = ["None None","ADMINI - ADMIN","EDUCAT - Education","EDUCATION - EDUCATION","FLTOPS - Flight Ops","GROUND - GROUND","STAFFI - Staffing","SPECEV - Special Events","MOBVAX - Mobile Vaccinations","VENETI - Venetian","SNHDVX - SNHD Vaccinations"
    ]
    
    static let costCenterDictionary = ["None": "None","ADMINI - ADMIN": "Admin","EDUCAT - Education": "Education","EDUCATION - EDUCATION": "EDUCATION","FLTOPS - Flight Ops": "FlightOps","GROUND - GROUND": "Ground","STAFFI - Staffing": "Staffing","SPECEV - Special Events": "SpecialEvents","MOBVAX - Mobile Vaccinations": "MobileVaccinations","VENETI - Venetian": "Venetian","SNHDVX - SNHD Vaccinations": "SNHDVaccinations"
    ]
    static let qualificationsDictionary = ["None": "None","Admin": "Admin","AEMT": "AEMT","AOC": "AOC","CCT Paramedic": "CCT Paramedic","EMT": "EMT","GOC": "GOC","Nurse": "Nurse","Paramedic": "Paramedic","CFRN": "CFRN","CCRN": "CCRN","CEN": "CEN","Instructor": "Instructor","MD": "MD","EMT Intern": "EMT Intern","Paramedic Interm": "Paramedic Intern","CCT Intern": "CCT Intern","Dispatcher": "Dispatcher","COVID Tester": "COVID Tester","RT": "RT","Vaccinator": "Vaccinator","Site Lead": "Site Lead","PR": "PR","Data Entry": "Data Entry"
    ]
    static let cellPhoneServices = ["Service","AT&T", "Verizon", "T-Mobile", "Sprint"]
    
    // Need to create a place here to store all the images I am using.
    // that way I dont use the name just there. And i use the actual value
    
    // Or I can use an enum for the photos that I want to use
    
    //static let
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        //dateFormatter.timeZone = TimeZone.current
        //dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date) // replace Date String
    }
}
