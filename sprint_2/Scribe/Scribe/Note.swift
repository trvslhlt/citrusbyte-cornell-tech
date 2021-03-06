//
//  Note.swift
//  Scribe
//
//  Created by trvslhlt on 10/21/16.
//  Copyright © 2016 travis holt. All rights reserved.
//

import Foundation

class Note {
    
    let patient: String
    let date: Date
    let transcription: String
    
    init(patient: String, date: Date, transcription: String) {
        self.patient = patient
        self.date = date
        self.transcription = transcription
    }
    
    func shortTimeFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    func longTimeFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .long
        return dateFormatter.string(from: date)
    }
    
}
