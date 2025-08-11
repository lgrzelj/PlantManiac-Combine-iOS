//
//  ContentView.swift
//  PlantManiac
//
//  Created by ASELab on 21.07.2025..
//

import SwiftUI

struct WelcomeScreen: View {
    var body: some View {
        
        NavigationStack{
            ZStack {
                
                Color("PrimaryBackgroundColor")
                    .ignoresSafeArea()
                
                VStack (spacing: 20){
                    Spacer()
                    Image( "LogoIcon")
                        .resizable()
                        .frame(width: 100, height:100)
                    
                    Text(NSLocalizedString("welcome_message", comment: "Poruka dobrodošllice."))
                        .font(.custom("Georgia-Italic", size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.accent)
                        .padding(.bottom,65)
                    
                    //NavigationLink fo declarative approach
                    NavigationLink(destination: SignIn()){
                        
                        Text(NSLocalizedString("sign_in", comment: "Prijava korisnika."))
                            .font(.custom("Georgia", size: 22))
                            .foregroundColor(.accent)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20)
                                .fill(Color("ButtonColor")))
                    }
                    .padding(.horizontal,65)
                    
                    
                    NavigationLink(destination: Registration()){
                        Text(NSLocalizedString("registration", comment: "Registracija korisnika."))
                            .font(.custom("Georgia", size: 22))
                            .foregroundColor(.accent)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20)
                                .fill(Color("ButtonColor")))
                        
                    }
                            .padding(.horizontal, 65)
                    
                    Spacer()
                    
                }
                .padding()
                
            }
        }
        }
        
}

#Preview {
    WelcomeScreen()
}
