//
//  SavePlant.swift
//  PlantManiac
//
//  Created by ASELab on 03.08.2025..
//

import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

func savePlantToFirestore(plant: PlantDetailsModel, imageUrl: String, completion: @escaping (Error?) -> Void) {
    let db = Firestore.firestore()
    guard let user = Auth.auth().currentUser else {
        completion(NSError(domain: "auth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nema prijavljenog korisnika."]))
        return
    }

    let plantData: [String: Any] = [
        "userId": user.uid,
        "name": plant.name,
        "description": plant.description,
        "summary": plant.summary,
        "sunlight": plant.sunlight,
        "watering": plant.watering,
        "temperature": plant.temperature,
        "humidity": plant.humidity,
        "careLevel": plant.careLevel,
        "price": plant.price,
        "imageUrl": imageUrl,
        "createdAt": FieldValue.serverTimestamp()
    ]

    db.collection("saved_plants").addDocument(data: plantData) { error in
        completion(error)
    }
}
