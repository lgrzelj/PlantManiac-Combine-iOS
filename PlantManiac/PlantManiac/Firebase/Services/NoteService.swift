//
//  NoteService.swift
//  PlantManiac
//
//  Created by ASELab on 06.08.2025..
//

import FirebaseAuth
import FirebaseFirestore

func saveNoteToFirestore(noteText: String, selectedDate: Date) {
    guard let userID = Auth.auth().currentUser?.uid else {
        print("User not authenticated.")
        return
    }

    let db = Firestore.firestore()
    
    let newNote = NotesFirestoreModel(
        userID: userID,
        note: noteText,
        createdAt: selectedDate,
        reminder: false,
        reminderDate: Date(), 
        repeats: false
    )
    
    do {
        try db.collection("diary_notes")
            .addDocument(from: newNote)
        print("Note successfully saved.")
    } catch {
        print("Error saving note: \(error.localizedDescription)")
    }
}
