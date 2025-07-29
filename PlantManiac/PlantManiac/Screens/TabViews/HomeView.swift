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
        VStack(spacing: 0) {
            Spacer()
            Group {
                switch selectedTab {
                case .home:
                    Text("Home")
                case .liked:
                    Text("Liked")
                    LikedView()
                case .scan:
                    Text("Scan")
                    ScanView()
                case .diary:
                    Text("Diary")
                    DiaryView()
                case .profile:
                    Text("Profile")
                    ProfileView()
                }
                Spacer()
                CustomTabBar(selected: $selectedTab)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        
    }
}

#Preview {
    HomeView()
}
