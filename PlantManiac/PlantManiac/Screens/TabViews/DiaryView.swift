//
//  DiaryView.swift
//  PlantManiac
//
//  Created by ASELab on 28.07.2025..
//

import SwiftUI

struct DiaryView: View {
    
    @ObservedObject var plantsList: PlantListViewModel
    @State private var searchText = ""
    @State private var selectedSearch: String? = nil
    
    @State private var showReminderSheet = false
    @ObservedObject var notesViewModel = NotesViewModel()

    
    var body: some View {
        ZStack{
            Color("PrimaryBackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                
                Text(NSLocalizedString("diary", comment: ""))
                    .font(.custom("Georgia-BoldItalic", size: 24))
                    .foregroundColor(.accentColor)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                VStack(spacing: 0) {
                    HStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.gray)
                            
                            TextField("search_plant", text: $searchText)
                                .font(.custom("Georgia", size: 16))
                                .foregroundColor(.primary)
                                .disabled(plantsList.plants.isEmpty)
                                .autocorrectionDisabled()
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 40)
                        .background(Color(.button))
                        .cornerRadius(20)
                        
                        Button(action: {
                            notesViewModel.fetchAllNotes()
                            showReminderSheet = true
                        }) {
                            Image(systemName: "alarm")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.black)
                        }
                        .sheet(isPresented: $showReminderSheet) {
                            ReminderSelectionView(notesViewModel: notesViewModel)
                        }

                    }
                    .padding(.horizontal, 20)
                    
                    if !searchText.isEmpty {
                        let suggestions = plantsList.plants.filter {
                            $0.name.localizedCaseInsensitiveContains(searchText)
                        }
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(suggestions) { plant in
                                    Button(action: {
                                        selectedSearch = plant.name
                                        searchText = ""
                                    }) {
                                        Text(plant.name)
                                            .padding(.vertical, 6)
                                            .padding(.horizontal, 12)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .foregroundColor(.primary)
                                    }
                                    .background(Color.white)
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                        }
                        .frame(maxHeight: 120)
                        
                        if !searchText.isEmpty && suggestions.isEmpty {
                            Text("\(NSLocalizedString("no_results", comment: "")) \"\(searchText)\"")

                                .font(.custom("Georgia", size: 14))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 20)
                                .padding(.top, 4)
                        }

                    }
                }
                .padding(.bottom, 10)
                
                
                let filteredPlants: [PlantFirestoreModel] = {
                    if let selected = selectedSearch {
                        return plantsList.plants.filter { $0.name == selected }
                    } else {
                        return plantsList.plants
                    }
                }()
                
                if plantsList.plants.isEmpty {
                    Text("scan_plants")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                }
                
                if selectedSearch != nil {
                    Button("unfiltered_plants") {
                        selectedSearch = nil
                    }
                    .font(.caption)
                    .padding(.bottom, 10)
                }
                
                ScrollView {
                    
                    ForEach(filteredPlants) { plant in
                        PlantListView(plant: plant, onLikeToggle: {
                            plantsList.toggleLike(for: plant)
                        })
                    }
                    
                }
                .blur(radius: searchText.isEmpty ? 0 : 5)
                .allowsHitTesting(searchText.isEmpty)
                .animation(.easeInOut(duration: 0.3), value: searchText)
                .padding(.bottom, 10)
                
                Text("notes")
                    .font(.custom("Georgia-Bold", size: 20))
                    .foregroundColor(.accent)
                    .padding(.bottom, 10)
                
                HStack {
                    DiaryDateEntryView()
                    Spacer()
                }
                .padding()
            }
        }
    }
}
#Preview{
    let testViewModel = PlantListViewModel()
    
    testViewModel.plants = [
        PlantFirestoreModel(
            id: "1",
            userID: "324",
            name: "Monstera deliciosa",
            probability: 3,
            description: String(repeating: "Monstera deliciosa, ", count: 50),
            summary: "Summary......",
            watering: "3-4",
            sunlight: ["Bright", "indirect light"],
            temperature: "50",
            humidity: "50%",
            careLevel: 4,
            price: "40",
            isLiked: true
        ),
        PlantFirestoreModel(
            id: "2",
            userID: "22",
            name: "Ficus lyrata",
            probability: 2,
            description: "Ficus lyrata description.",
            summary: "Popular indoor tree.",
            watering: "1-2",
            sunlight: ["Bright light"],
            temperature: "65-75",
            humidity: "60%",
            careLevel: 3,
            price: "55",
            isLiked: false
        )
    ]
    
    return DiaryView(plantsList: testViewModel)
}
