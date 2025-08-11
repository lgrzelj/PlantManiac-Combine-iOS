//
//  ReminderSelectionView.swift
//  PlantManiac
//
//  Created by ASELab on 07.08.2025..
//

import SwiftUI

struct ReminderSelectionView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    
    var body: some View {
        NavigationView {
                    List {
                        Section(header: Text("all_notes")
                            .font(.custom("Georgia-Italic", size: 16))
                            .foregroundColor(.accent)
                        ) {
                            ForEach(Array(notesViewModel.allNotes.enumerated()), id: \.offset) { index, note in
                                NavigationLink(destination: NoteDetailView(note: note, notesViewModel: notesViewModel)) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text(note.note)
                                                .font(.custom("Georgia", size: 16))
                                            
                                            Text(note.createdAt, style: .date)
                                                .font(.custom("Georgia", size: 12))
                                                .foregroundColor(.gray)
                                            
                                            if note.repeats {
                                                Text("🔁 \(NSLocalizedString("repeats", comment: ""))")
                                                    .font(.custom("Georgia", size: 12))
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color(.tabSelect.opacity(0.5)))
                                    .cornerRadius(15)
                                }
                                .listRowBackground(Color.clear)
                            }
                        }
                        
                        Section(header: Text("future_reminders")
                                          .font(.custom("Georgia-Italic", size: 16))
                                          .foregroundColor(.accent)
                                      ) {
                                          let now = Date()
                                          let futureReminders = notesViewModel.allNotes.filter { note in
                                              note.reminder && (note.reminderDate ?? Date.distantPast) > now
                                          }
                                          
                                          ForEach(Array(futureReminders.enumerated()), id: \.offset) { index, note in
                                              NavigationLink(destination: NoteDetailView(note: note, notesViewModel: notesViewModel)) {
                                                  HStack {
                                                      VStack(alignment: .leading, spacing: 10) {
                                                          Text(note.note)
                                                              .font(.custom("Georgia", size: 16))
                                                          
                                                          Text(note.reminderDate ?? Date(), style: .date)
                                                              .font(.custom("Georgia", size: 12))
                                                              .foregroundColor(.red)
                                                          
                                                          if note.repeats {
                                                              Text("🔁 \(NSLocalizedString("repeats", comment: ""))")
                                                                  .font(.custom("Georgia", size: 12))
                                                                  .foregroundColor(.blue)
                                                          }
                                                      }
                                                      Spacer()
                                                  }
                                                  .padding(.vertical, 8)
                                                  .padding(.horizontal, 12)
                                                  .background(Color.yellow.opacity(0.3))
                                                  .cornerRadius(15)
                                              }
                                              .listRowBackground(Color.clear)
                                          }
                                      }
                                      
                                      // Notes with expired reminders
                                      Section(header: Text("expired_reminders")
                                          .font(.custom("Georgia-Italic", size: 16))
                                          .foregroundColor(.accent)
                                      ) {
                                          let now = Date()
                                          let expiredReminders = notesViewModel.allNotes.filter { note in
                                              note.reminder && (note.reminderDate ?? Date.distantFuture) <= now
                                          }
                                          
                                          ForEach(Array(expiredReminders.enumerated()), id: \.offset) { index, note in
                                              NavigationLink(destination: NoteDetailView(note: note, notesViewModel: notesViewModel)) {
                                                  HStack {
                                                      VStack(alignment: .leading, spacing: 10) {
                                                          Text(note.note)
                                                              .font(.custom("Georgia", size: 16))
                                                          
                                                          Text(note.reminderDate ?? Date(), style: .date)
                                                              .font(.custom("Georgia", size: 12))
                                                              .foregroundColor(.gray)
                                                          
                                                          if note.repeats {
                                                              Text("🔁 \(NSLocalizedString("repeats", comment: ""))")
                                                                  .font(.custom("Georgia", size: 12))
                                                                  .foregroundColor(.blue)
                                                          }
                                                      }
                                                      Spacer()
                                                  }
                                                  .padding(.vertical, 8)
                                                  .padding(.horizontal, 12)
                                                  .background(Color.red.opacity(0.2))
                                                  .cornerRadius(15)
                                              }
                                              .listRowBackground(Color.clear)
                                          }
                                      }
                                  }
                                  .navigationTitle("select_note")
                                  .font(.custom("Georgia", size: 25))
                                  .navigationBarTitleDisplayMode(.inline)
                              }
                          }
}
