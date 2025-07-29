//
//  ContentView.swift
//  PlantManiac
//
//  Created by ASELab on 21.07.2025..
//

import SwiftUI

struct ContentView: View {
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
                    
                    Text("Welcome to Plant Maniac, for further app access choose an option.")
                        .font(.custom("Georgia-Italic", size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.accent)
                        .padding(.bottom,65)
                    
                    //NavigationLink fo declarative approach
                    NavigationLink(destination: SignIn()){
                        
                        Text("Sign in")
                            .font(.custom("Georgia", size: 22))
                            .foregroundColor(.accent)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20)
                                .fill(Color("ButtonColor")))
                    }
                    .padding(.horizontal,65)
                    
                    
                    NavigationLink(destination: Registration()){
                        Text("Registration")
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
    ContentView()
    
}
