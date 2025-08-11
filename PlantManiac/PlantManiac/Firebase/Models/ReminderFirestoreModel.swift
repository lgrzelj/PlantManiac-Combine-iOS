//
//  MoteFirestoreModel.swift
//  PlantManiac
//
//  Created by ASELab on 10.08.2025..
//

import Foundation
import FirebaseFirestore

struct ReminderFirestoreModel: Identifiable, Codable {
    @DocumentID var id: String?
    var userID: String
    var text: String
    var notificationDate: Date
}
