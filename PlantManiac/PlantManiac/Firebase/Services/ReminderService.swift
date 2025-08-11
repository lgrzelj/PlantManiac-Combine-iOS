//
//  ReminderService.swift
//  PlantManiac
//
//  Created by ASELab on 10.08.2025..
//

import Foundation
import FirebaseFirestore
import Combine

class ReminderService {
    
    static let shared = ReminderService() // Singleton
    private let db = Firestore.firestore()
    
    private init() {}
    
    func saveNoteToFirestore(reminder: ReminderFirestoreModel) {
        let db = Firestore.firestore()
        do {
            try db.collection("notifications").document(reminder.id ?? "").setData(from: reminder)
        } catch {
            print("Error saving note: \(error)")
        }
    }
    
    func fetchReminders(for uid: String, on date: Date) -> AnyPublisher<[ReminderFirestoreModel], Error> {
        Future<[ReminderFirestoreModel], Error> { promise in
            let db = Firestore.firestore()
            
            // Kreiraj interval od početka do kraja dana za query
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid date range"])))
                return
            }
            
            db.collection("notifications")
                .whereField("userID", isEqualTo: uid)
                .whereField("notificationDate", isGreaterThanOrEqualTo: startOfDay)
                .whereField("notificationDate", isLessThan: endOfDay)
                .getDocuments { snapshot, error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    guard let documents = snapshot?.documents else {
                        promise(.success([]))
                        return
                    }
                    
                    let reminders: [ReminderFirestoreModel] = documents.compactMap { doc in
                        try? doc.data(as: ReminderFirestoreModel.self)
                    }
                    promise(.success(reminders))
                }
        }
        .eraseToAnyPublisher()
    }
    
}
