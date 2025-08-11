//
//  NoteDetailView.swift
//  PlantManiac
//
//  Created by ASELab on 08.08.2025..
//


import SwiftUI
import FirebaseAuth

struct NoteDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var note: NotesFirestoreModel
    @StateObject var notesViewModel: NotesViewModel
    @StateObject var plantListViewModel = PlantListViewModel()

    var body: some View {
        ScrollView {
                  VStack(alignment: .leading, spacing: 16) {

                      HStack(spacing: 8) {
                                          Image(systemName: "note.text")
                                              .frame(width: 24, height: 24)
                                              .foregroundColor(.primary)
                                          Text(NSLocalizedString("note", comment: ""))
                                              .font(.headline)
                                      }
                      TextField(NSLocalizedString("enter_note", comment: ""), text: $note.note)
                          .textFieldStyle(RoundedBorderTextFieldStyle())
                      
                      Divider()

                      HStack(spacing: 8) {
                                        Image(systemName: "calendar")
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.primary)
                                        Text(NSLocalizedString("Created At", comment: ""))
                                            .font(.headline)
                                    }
                      Text(note.createdAt.formatted(date: .long, time: .shortened))
                          .font(.body)

                      Divider()

                      HStack(spacing: 8) {
                                        Image(systemName: "alarm")
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.primary)
                                        Text(NSLocalizedString("reminder", comment: ""))
                                            .font(.headline)
                                    }
                      Toggle(NSLocalizedString("enable_reminder", comment: ""), isOn: $note.reminder)
                          .toggleStyle(SwitchToggleStyle(tint: .accentColor))

                      if note.reminder {
                          DatePicker(NSLocalizedString("reminder_date", comment: ""), selection: $note.reminderDate, displayedComponents: [.date, .hourAndMinute])
                              .datePickerStyle(.compact)
                      }

                      Divider()

                      HStack(spacing: 8) {
                                         Image(systemName: "repeat")
                                             .frame(width: 24, height: 24)
                                             .foregroundColor(.primary)
                                         Text(NSLocalizedString("repeats", comment: ""))
                                             .font(.headline)
                                     }
                      Toggle(NSLocalizedString("repeats", comment: ""), isOn: $note.repeats)
                          .toggleStyle(SwitchToggleStyle(tint: .accentColor))

                      Divider()

                      Button(action: {
                          notesViewModel.update(note: note) { result in
                                  switch result {
                                  case .success:
                                      print("Note updated successfully.")
                                      presentationMode.wrappedValue.dismiss()
                                      
                                      if note.reminder {
                                          guard let uid = Auth.auth().currentUser?.uid else {
                                              print("No user logged in, cannot save reminder.")
                                              return
                                          }

                                          let reminder = ReminderFirestoreModel(
                                              id: note.id ?? UUID().uuidString,
                                              userID: uid,
                                              text: note.note,
                                              notificationDate: note.reminderDate
                                          )

                                          ReminderService.shared.saveNoteToFirestore(reminder: reminder)
                                          UserNotificationsService.shared.scheduleNotification(for: reminder)
                                      } else if let id = note.id {
                                          UserNotificationsService.shared.cancelReminder(noteID: id)
                                      }

                                      notesViewModel.fetchAllNotes()
                                      plantListViewModel.fetchPlants()

                                      presentationMode.wrappedValue.dismiss()

                                  case .failure(let error):
                                      print("Failed to update note: \(error.localizedDescription)")
                                  }
                              }
                      }) {
                          Text(NSLocalizedString("save_changes", comment: ""))
                              .font(.headline)
                              .frame(maxWidth: .infinity)
                              .padding()
                              .background(Color.accentColor)
                              .foregroundColor(.white)
                              .cornerRadius(10)
                      }

                      Spacer()
                      
                      Button(action: {
                          notesViewModel.delete(note: note) { result in
                              switch result {
                              case .success:
                                  print("Note deleted successfully.")
                                  presentationMode.wrappedValue.dismiss()
                              case .failure(let error):
                                  print("Failed to delete note: \(error.localizedDescription)")
                              }
                          }
                      }) {
                          Text(NSLocalizedString("delete_note", comment: ""))
                              .font(.headline)
                              .frame(maxWidth: .infinity)
                              .padding()
                              .background(Color.red)
                              .foregroundColor(.white)
                              .cornerRadius(10)
                      }

                      Spacer()
                  }
                  .padding()
              }
              .background(Color.gray.opacity(0.1))
              .navigationTitle(NSLocalizedString("note_details", comment: ""))
              .navigationBarTitleDisplayMode(.inline)
          }
}
