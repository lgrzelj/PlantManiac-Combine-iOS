//
//  PlantListViewModel.swift
//  PlantManiac
//
//  Created by ASELab on 04.08.2025..
//

import Foundation
import FirebaseFirestore
import Combine
import FirebaseAuth

class PlantListViewModel: ObservableObject {
    @Published var plants: [PlantFirestoreModel] = []
    @Published var filteredPlants: [PlantFirestoreModel] = []
    

    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    private var timer: AnyCancellable?

    init() {
        startAutoRefresh() // ponavljanje svakih 10 min
    }
    
    var isEmpty: Bool {
            plants.isEmpty
        }

    func fetchPlants() {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Korisnik nije prijavljen — dohvat biljaka preskočen.")
            return
        }
        print("Prijavljen korisnik: \(currentUserID)")

        db.collection("saved_plants")
            .whereField("userId", isEqualTo: currentUserID)
            .getDocuments { snapshot, error in
            if let error = error {
                print("Greška pri dohvaćanju: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            self.plants = documents.compactMap { doc in
                do {
                    return try doc.data(as: PlantFirestoreModel.self)
                } catch {
                    print("Greška kod dekodiranja dokumenta \(doc.documentID): \(error)")
                    return nil
                }
            }
        }
    }


    func startAutoRefresh() {
        timer = Timer.publish(every: 120, on: .main, in: .common) //2 min
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchPlants()
            }
    }
    
    
    
    func toggleLike(for plant: PlantFirestoreModel) {
           guard let index = plants.firstIndex(where: { $0.id == plant.id }) else { return }

           plants[index].isLiked.toggle()
            
        plants = plants

           let plantId = plants[index].id
        db.collection("saved_plants").document(plantId ?? " ").updateData([
               "isLiked": plants[index].isLiked
           ]) { error in
               if let error = error {
                   print("Failed to update isLiked for plant \(String(describing: plantId)): \(error)")
               } else {
                   print("Successfully updated isLiked for plant \(String(describing: plantId))")
               }
           }
       }

    func searchPlants(query: String){
        if query.isEmpty {
            filteredPlants = plants
        } else {
            filteredPlants = plants.filter {
                $0.name.localizedCaseInsensitiveContains(query)
            }
        }
    }
}
