//
//  SplashView.swift
//  PlantManiac
//
//  Created by ASELab on 25.07.2025..
//
import SwiftUI
import FirebaseAuth

struct SplashView: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity = 0.0
    
    @StateObject private var plantsList = PlantListViewModel()
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn = false

    var body: some View {
        if isActive {
                   if isUserLoggedIn {
                       HomeView(plantsList: plantsList)
                   } else {
                       WelcomeScreen()
                   }
               } else {
                   ZStack {
                       Color("PrimaryBackgroundColor")
                           .ignoresSafeArea()

                       VStack(spacing: 20) {
                           Image("LogoIcon")
                               .resizable()
                               .scaledToFit()
                               .frame(width: 120, height: 120)
                               .scaleEffect(logoScale)
                               .opacity(logoOpacity)

                           Text(NSLocalizedString("app_name", comment :"Naslov aplikcije"))
                               .font(.custom("Georgia-Italic", size: 32))
                               .foregroundColor(.accentColor)
                               .opacity(logoOpacity)
                       }
                   }
                   .onAppear {
                       withAnimation(.easeIn(duration: 1.2)) {
                           logoScale = 1.0
                           logoOpacity = 1.0
                       }

                       isUserLoggedIn = Auth.auth().currentUser != nil

                       DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                           withAnimation {
                               isActive = true
                           }
                       }
                   }
               }
           }
       }
