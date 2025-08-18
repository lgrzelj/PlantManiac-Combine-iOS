//
//  UserNotifications.swift
//  PlantManiac
//
//  Created by ASELab on 10.08.2025..
//

import Foundation
import UserNotifications
import Combine
import FirebaseFirestore

class UserNotificationsService{
    
    static let shared = UserNotificationsService()
    init() {}
    
    private let db = Firestore.firestore()
    
    func scheduleNotification(for note: ReminderFirestoreModel) {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("reminder_title", comment: "")
        content.body = note.text
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: note.notificationDate
        )
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: note.id ?? "", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }

    
    func cancelReminder(noteID: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [noteID])
        print("Reminder cancelled for note \(noteID)")
    }
    
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
           UNUserNotificationCenter.current()
               .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                   if let error = error {
                       print("Error requesting notification permission: \(error.localizedDescription)")
                   }
                   DispatchQueue.main.async {
                       completion(granted)
                   }
               }
       }
    
        //upotreba COMBINE
    func fetchReminders(for uid: String, on date: Date) -> AnyPublisher<[ReminderFirestoreModel], Error> {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        return Future<[ReminderFirestoreModel], Error> { promise in
            self.db.collection("users").document(uid).collection("notifications")
                .whereField("notificationDate", isGreaterThanOrEqualTo: startOfDay)
                .whereField("notificationDate", isLessThan: endOfDay)
                .getDocuments { snapshot, error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    let reminders = snapshot?.documents.compactMap { doc -> ReminderFirestoreModel? in
                        try? doc.data(as: ReminderFirestoreModel.self)
                    } ?? []
                    promise(.success(reminders))
                }
        }
        .eraseToAnyPublisher()
    }

}
