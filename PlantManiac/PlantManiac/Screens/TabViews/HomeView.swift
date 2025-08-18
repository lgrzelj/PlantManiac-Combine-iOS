//
//  SwiftUIView.swift
//  PlantManiac
//
//  Created by ASELab on 26.07.2025..
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @State private var selectedTab: TabItem = .home
    @Namespace private var animation
    @ObservedObject var plantsList: PlantListViewModel
    
    var body: some View {
        NavigationStack{
            ZStack (alignment: .bottom){
                Color("PrimaryBackgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    selectedTabOption(selectedTab: selectedTab)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.bottom, 80)
                }
                
                CustomTabBar(selected: $selectedTab)
                    .ignoresSafeArea(edges: .bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            .onAppear {
                if let _ = Auth.auth().currentUser {
                    plantsList.fetchPlants()
                    
                } else {
                    print("Korisnik nije prijavljen, ne dohvaćam biljke.")
                }
            }
            
        }
        
    }
    @ViewBuilder
    func selectedTabOption(selectedTab: TabItem) -> some View{
        switch selectedTab {
        case .home:
            ScrollView {
                VStack(spacing: 16) {
                    Text(NSLocalizedString("home", comment: ""))
                        .font(.custom("Georgia-BoldItalic", size: 24))
                        .foregroundStyle(.accent)
                        .padding()
                    
                    if plantsList.isEmpty {
                               Text("scan_plants")
                                   .font(.headline)
                                   .foregroundColor(.gray)
                                   .multilineTextAlignment(.center)
                                   .padding()
                    } else {
                            ForEach(plantsList.plants) { plant in
                                
                                PlantListView(plant: plant, onLikeToggle: {  plantsList.toggleLike(for: plant)})
                            }
                        
                    }
                }
                .padding(.vertical)
            }
            
        case .liked:
            LikedView(plantsList: plantsList)
        case .scan:
            ScanView()
        case .diary:
            DiaryView(plantsList: plantsList)
        case .profile:
            ProfileView(plantsList: plantsList)
        }
    }
}
