//
//  LikedView.swift
//  PlantManiac
//
//  Created by ASELab on 28.07.2025..
//

import SwiftUI

struct LikedView: View {
    @ObservedObject var plantsList: PlantListViewModel
    
    var body: some View {
        ZStack{
            Color("PrimaryBackgroundColor")
                .ignoresSafeArea()
            
            ScrollView{
                
                VStack {
                    
                    Text(NSLocalizedString("liked", comment: ""))
                        .font(.custom("Georgia-BoldItalic", size: 24))
                        .foregroundColor(.accentColor)
                        .padding(.top, 30)
                        .padding(.bottom, 20)
                   
                    if plantsList.isEmpty {
                               Text("like_plants")
                                   .font(.headline)
                                   .foregroundColor(.gray)
                                   .multilineTextAlignment(.center)
                                   .padding()
                    } else {
                        ForEach(plantsList.plants.filter { $0.isLiked }) { plant in
                            PlantListView(plant: plant) {
                                withAnimation {
                                    plantsList.toggleLike(for: plant)
                                }
                            }
                        }
                    }

                }
            }
           
        }
    }
}


