//
//  NotesFirestoreModel.swift
//  PlantManiac
//
//  Created by ASELab on 06.08.2025..
//

import Foundation
import FirebaseFirestore

struct NotesFirestoreModel: Codable, Identifiable {
    @DocumentID var id: String?
    var userID: String
    var note: String
    var createdAt: Date
    var reminder: Bool
    var reminderDate: Date
    var repeats: Bool
}
