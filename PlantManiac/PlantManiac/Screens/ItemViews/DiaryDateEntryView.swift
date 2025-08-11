//
//  DateEntryView.swift
//  PlantManiac
//
//  Created by ASELab on 05.08.2025..
//

import Foundation

import SwiftUI

struct DiaryDateEntryView: View {
    @State private var selectedDate = Date()
    @State private var noteText = ""
    @ObservedObject private var notesVM = NotesViewModel()
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 16) {
            
            VStack(spacing: 6) {
                
                GeometryReader { geo in
                    DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .scaleEffect(0.45, anchor: .topLeading)
                        .frame(width: geo.size.width * (1 / 0.45), height: geo.size.height * (1 / 0.45))
                        .clipped()
                }
                .frame(width: 150, height: 150)
                
                TextField("write_note", text: $noteText)
                    .font(.caption)
                    .padding(4)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
                    .frame(height: 26)
                    .autocorrectionDisabled()
                
                Button(action:{
                    saveNoteToFirestore(noteText: noteText, selectedDate: selectedDate)
                    
                    print("Saved: \(selectedDate), note: \(noteText)")
                    notesVM.fetchNotesForCurrentMonth()
                    noteText = ""
                }) {
                    Text("save")
                        .font(.custom("Georgia", size: 16))
                        .foregroundColor(.accent)
                        .frame(maxWidth: .infinity)
                        .background(Color(.button))
                        .cornerRadius(10)
                        .padding(5)
                }
            }
            .frame(width: 170, height: 220)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
           
            VStack(alignment: .leading, spacing: 8) {
                Text("notes_month")
                    .font(.custom("Georgia-Italic", size: 20))
                    .foregroundColor(.accent)
               
                ScrollView {
                    LazyVStack(spacing: 8) {
                        
                        if notesVM.notes.isEmpty {
                            Text("add_notes")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                        } else{
                            
                            ForEach(notesVM.notes, id: \.createdAt) { note in
                                        VStack(alignment: .leading, spacing: 4) {
                                                           Text(note.note)
                                                               .font(.custom("Georgia", size: 15))
                                                               .lineLimit(6)
                                                               .multilineTextAlignment(.leading)
                                                               .frame(maxWidth: .infinity, alignment: .leading)
                                                               .foregroundColor(.accent)

                                                           Text(note.createdAt.formatted(date: .abbreviated, time: .omitted))
                                                               .font(.custom("Georgia", size: 12))
                                                               .foregroundColor(.gray)
                                                       }
                                                       .padding(6)
                                                       .frame(maxWidth: .infinity)
                                                       .background(Color.tabSelect.opacity(0.5))
                                                       .cornerRadius(6)
                                                   }
                        }
                       
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            notesVM.fetchNotesForCurrentMonth()
        }
    }
}

#Preview{
    DiaryDateEntryView()
}
