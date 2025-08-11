//
//  NotesViewModel.swift
//  PlantManiac
//
//  Created by ASELab on 07.08.2025..
//
import Foundation
import FirebaseFirestore
import Combine
import FirebaseAuth

class NotesViewModel: ObservableObject {
    @Published var notes: [NotesFirestoreModel] = []
    @Published var allNotes: [NotesFirestoreModel] = []

    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?
    
    init() {
        timerCancellable = Timer
            .publish(every: 120, on: .main, in: .common)
            .autoconnect()
            .prepend(Date()) 
            .sink { [weak self] _ in
                self?.fetchNotesForCurrentMonth()
                self?.fetchAllNotes()
            }
    }
    

    func fetchNotesForCurrentMonth() {
        guard let userID = Auth.auth().currentUser?.uid else {
                      print("User not authenticated.")
                      return
        }
        
        let db = Firestore.firestore()
        let start = Date().startOfMonth
        let end = Date().endOfMonth

        db.collection("diary_notes")
            .whereField("userID", isEqualTo: userID)
            .whereField("createdAt", isGreaterThanOrEqualTo: start)
            .whereField("createdAt", isLessThanOrEqualTo: end)
            .order(by: "createdAt", descending: false)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching notes: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self?.notes = documents.compactMap { doc in
                    try? doc.data(as: NotesFirestoreModel.self)
                }
            }
        
        print("Fetched notes count: \(self.notes.count)")

    }

    deinit {
        timerCancellable?.cancel()
    }
    
    func fetchAllNotes() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            return
        }

        let db = Firestore.firestore()
        db.collection("diary_notes")
            .whereField("userID", isEqualTo: userID)
            .order(by: "createdAt", descending: true)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching all notes: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self?.allNotes = documents.compactMap { doc in
                    try? doc.data(as: NotesFirestoreModel.self)
                }
            }
    }
    
    func update(note: NotesFirestoreModel, completion: @escaping (Result<Void, Error>) -> Void) {
           guard let noteID = note.id else {
               completion(.failure(NSError(domain: "Invalid note ID", code: -1, userInfo: nil)))
               return
           }
           let db = Firestore.firestore()

           let data: [String: Any] = [
               "note": note.note,
               "reminder": note.reminder,
               "reminderDate": note.reminderDate,
               "repeats": note.repeats
           ]

           db.collection("diary_notes").document(noteID).updateData(data) { error in
               if let error = error {
                   completion(.failure(error))
               } else {
                   completion(.success(()))
               }
           }
       }

    func delete(note: NotesFirestoreModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        
        guard let noteId = note.id else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Note ID not found."])))
            return
        }
        
        db.collection("diary_notes").document(noteId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {

                DispatchQueue.main.async {
                    self.notes.removeAll {$0.id == noteId }
                    self.allNotes.removeAll { $0.id == noteId }
                }
                completion(.success(()))
            }
        }
    }
 

    func updateNoteAndHandleNotification(note: NotesFirestoreModel, saveNoteToFirestore: @escaping (ReminderFirestoreModel) -> Void, presentationModeDismiss: @escaping () -> Void) {
        update(note: note) { [weak self] result in
            switch result {
            case .success:
                guard let self = self, let uid = Auth.auth().currentUser?.uid else {
                    presentationModeDismiss()
                    return
                }
                Publishers.Zip(
                    AuthService.shared.fetchNotificationsPreference(),
                    ReminderService.shared.fetchReminders(for: uid, on: note.reminderDate)
                )
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            print("Error fetching user notification settings or reminders: \(error.localizedDescription)")
                        }
                    },
                    receiveValue: { notificationsEnabled, remindersForDay in
                        if notificationsEnabled {
                            if remindersForDay.contains(where: { $0.id == note.id }) {
                                print("Reminder for this note already exists today.")
                            } else if note.reminder {
                                let reminder = ReminderFirestoreModel(
                                    id: note.id ?? UUID().uuidString,
                                    userID: note.userID,
                                    text: note.note,
                                    notificationDate: note.reminderDate
                                )
                                saveNoteToFirestore(reminder)
                                UserNotificationsService.shared.scheduleNotification(for: reminder)
                            } else if let id = note.id {
                                UserNotificationsService.shared.cancelReminder(noteID: id)
                            }
                        } else {
                            print("User has disabled notifications.")
                        }
                        presentationModeDismiss()
                    }
                )
                .store(in: &self.cancellables)
                
            case .failure(let error):
                       print("Failed to update note: \(error.localizedDescription)")
                       presentationModeDismiss()
                   }
            }
        }
    }


extension Date {
    var startOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }

    var endOfMonth: Date {
        let start = self.startOfMonth
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: start)!
    }
}

