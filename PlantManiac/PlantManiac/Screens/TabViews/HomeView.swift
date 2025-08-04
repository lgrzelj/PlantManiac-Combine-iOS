//
//  SwiftUIView.swift
//  PlantManiac
//
//  Created by ASELab on 26.07.2025..
//

import SwiftUI


struct HomeView: View {
    @State private var selectedTab: TabItem = .home
    @Namespace private var animation
    
    var body: some View {
        
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

    }
}
       
@ViewBuilder
    func selectedTabOption(selectedTab: TabItem) -> some View{
        switch selectedTab {
        case .home:
            VStack{
                Text(NSLocalizedString("home", comment: ""))
                    .font(.custom("Georgia-BoldItalic", size: 24))
                    .foregroundStyle(.accent)
                    .padding()
                Spacer()
            }
            
        case .liked:
            LikedView()
        case .scan:
            ScanView()
        case .diary:
            DiaryView()
        case .profile:
            ProfileView()
        }
    }


#Preview {
    HomeView()
}
